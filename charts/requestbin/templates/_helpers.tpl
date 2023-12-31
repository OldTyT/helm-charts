{{/*
Expand the name of the chart.
*/}}
{{- define "requestbin.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "requestbin.fullname" -}}
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
{{- define "requestbin.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "requestbin.labels" -}}
helm.sh/chart: {{ include "requestbin.chart" . }}
{{ include "requestbin.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "requestbin.selectorLabels" -}}
app.kubernetes.io/name: {{ include "requestbin.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "requestbin.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "requestbin.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Generate the fullname of redis subchart */}}
{{- define "requestbin.redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "requestbin.extraEnvs" -}}
{{- if .Values.env }}
  {{- if (kindIs "map" .Values.env) }}
    {{- range $key, $value := .Values.env }}
- name: {{ $key }}
  value: {{ $value | quote }}
    {{- end -}}
  {{/* support previous schema */}}
  {{- else }}
{{- toYaml .Values.env }}
  {{- end }}
{{- end }}
{{- end }}
