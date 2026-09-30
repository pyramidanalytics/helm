{{/*
Expand the name of the chart.
*/}}
{{- define "pyramidAnalytics.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pyramidAnalytics.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pyramidAnalytics.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pyramidAnalytics.labels" -}}
helm.sh/chart: {{ include "pyramidAnalytics.chart" . }}
{{ include "pyramidAnalytics.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pyramidAnalytics.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pyramidAnalytics.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{- define "pyramidAnalytics.baseEnv" -}}
- name: PYRAMID_DOCKER_REGISTRY
  value: "{{ .Values.repo }}"
- name: host_name
  valueFrom:
    fieldRef:
      fieldPath: status.podIP
- name: machine_desc
  valueFrom:
    fieldRef:
      fieldPath: metadata.name
- name: namespace
  valueFrom:
    fieldRef:
      fieldPath: metadata.namespace
{{- end }}


{{- define "pyramidAnalytics.podSecurityContext" -}}
  securityContext:
    runAsNonRoot: true
    runAsUser: 1001
    runAsGroup: 1001
    fsGroup: 1001
{{- end }}

{{- define "pyramidAnalytics.containerSecurityContext" -}}
  securityContext:
    allowPrivilegeEscalation: false
{{- end }}

{{- define "pyramidAnalytics.dbMtls.mountPath" -}}
{{- (.Values.dbMtls | default dict).mountPath | default "/opt/pyramid/conf/db-certs" }}
{{- end }}

{{- define "pyramidAnalytics.dbMtls.mount" -}}
{{- $dbMtls := $.Values.dbMtls | default dict }}
{{- if $dbMtls.enabled }}
    volumeMounts:
    - name: db-client-certs
      mountPath: {{ include "pyramidAnalytics.dbMtls.mountPath" $ }}
      readOnly: true
{{- end }}
{{- end }}

{{- define "pyramidAnalytics.dbMtls.volume" -}}
{{- $dbMtls := $.Values.dbMtls | default dict }}
{{- if $dbMtls.enabled }}
volumes:
  - name: db-client-certs
    secret:
      secretName: {{ $dbMtls.secretName | default "pyramid-db-client-cert" }}
      defaultMode: 0440
{{- end }}
{{- end }}

{{- define "pyramidAnalytics.mount" -}}
{{- $storage := (not (eq "other" $.Values.storage.type)) }}
{{- $dbMtls := $.Values.dbMtls | default dict }}
{{- if or $storage $dbMtls.enabled }}
    volumeMounts:
{{- if $storage }}
    - name: persistent-storage
      mountPath: /opt/pyramid-repo
{{- end }}
{{- if $dbMtls.enabled }}
    - name: db-client-certs
      mountPath: {{ include "pyramidAnalytics.dbMtls.mountPath" $ }}
      readOnly: true
{{- end }}
{{- end }}
{{- end }}

{{- define "pyramidAnalytics.volume" -}}
{{- $storage := (not (eq "other" $.Values.storage.type)) }}
{{- $dbMtls := $.Values.dbMtls | default dict }}
{{- if or $storage $dbMtls.enabled }}
volumes:
{{- if $storage }}
- name: persistent-storage
  persistentVolumeClaim:
    claimName: {{ $.Values.storage.claim.name }}
{{- end }}
{{- if $dbMtls.enabled }}
- name: db-client-certs
  secret:
    secretName: {{ $dbMtls.secretName | default "pyramid-db-client-cert" }}
    defaultMode: 0440
{{- end }}
{{- end }}
{{- end }}

{{/*
Renders a nodeSelector block for a workload.
Pass a dict with:
  root  - the top-level context, $
  local - that workload's .Values.<service>.nodeSelector, may be nil
  skip  - that workload's .Values.<service>.disableGlobalNodeSelector, may be nil
A non-empty "local" selector always wins. Otherwise, unless "skip" is true, the global
.Values.nodeSelector is used. Set "skip" to true to opt a workload out of the global
default entirely (an empty "local" map can't be told apart from "unset", hence this flag).
*/}}
{{- define "pyramidAnalytics.nodeSelector" -}}
{{- $ns := .local -}}
{{- if not $ns -}}
{{- if not .skip -}}
{{- $ns = .root.Values.nodeSelector -}}
{{- end -}}
{{- end -}}
{{- if $ns -}}
nodeSelector:
{{- range $key, $value := $ns }}
  {{ $key }}: {{ $value | quote }}
{{- end }}
{{- end }}
{{- end }}

{{- define "pyramidAnalytics.unattended.json" -}}
{{- if .Values.unattended.enabled -}}
{{- /* Render the json field for unattended installation by converting .Values.unattended.installationData to json */ -}}
{{- with $dict := deepCopy .Values.unattended.installationData -}}
{{- if $.Values.dbMtls.enabled -}}
{{- $_ := unset $dict "dbPass" -}}
{{- end -}}
json: '{{ $dict | toJson }}'
{{- end }}
{{- end }}
{{- end }}
