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


{{/*
Environment variables shared across all deployments
*/}}
{{- define "pyramidAnalytics.baseEnv" -}}
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