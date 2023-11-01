{{- define "snippet.redis.protocol" -}}
{{ default "redis" .Values.externalRedis.protocol | quote }}
{{- end }}

{{- define "snippet.redis.host" -}}
{{ if not .Values.redis.enabled -}}
  {{ required "externalRedis.host is required if not redis.enabled" .Values.externalRedis.host | quote }}
{{- else -}}
  {{ include "requestbin.redis.fullname" . }}-master
{{- end }}
{{- end }}

{{- define "snippet.redis.port" -}}
{{ default 6379 .Values.externalRedis.port | quote }}
{{- end }}

{{- define "snippet.redis.database" -}}
{{ default 0 .Values.externalRedis.database | quote }}
{{- end }}

{{- define "snippet.redis.password.secret.name" -}}
{{ if .Values.redis.enabled -}}
  {{ if .Values.redis.auth.existingSecret -}}
    {{ .Values.redis.auth.existingSecret }}
  {{- else -}}
    {{ include "requestbin.redis.fullname" . }}
  {{- end }}
{{- else -}}
  {{ if .Values.externalRedis.existingSecret -}}
    {{ .Values.externalRedis.existingSecret }}
  {{- else -}}
    {{ include "requestbin.fullname" . }}-redis-external
  {{- end }}
{{- end }}
{{- end }}

{{- define "snippet.redis.password.secret.key" -}}
{{ if .Values.redis.enabled -}}
  {{ if .Values.redis.auth.existingSecret -}}
    {{ required "redis.auth.existingSecretPasswordKey is required if redis.auth.existingSecret is non-empty" .Values.redis.auth.existingSecretPasswordKey }}
  {{- else -}}
    redis-password
  {{- end }}
{{- else -}}
  {{ if .Values.externalRedis.existingSecret -}}
    {{ required "externalRedis.passwordKey is required if externalRedis.existingSecret is non-empty" .Values.externalRedis.passwordKey }}
  {{- else -}}
    redis-password
  {{- end }}
{{- end }}
{{- end }}

{{- define "snippet.redis.env" -}}
- name: REDIS_PROTOCOL
  value: {{ include "snippet.redis.protocol" . }}
- name: REDIS_HOST
  value: {{ include "snippet.redis.host" . }}
- name: REDIS_PORT
  value: {{ include "snippet.redis.port" . }}
- name: REDIS_DATABASE
  value: {{ include "snippet.redis.database" . }}
- name: REDIS_USERNAME
  value: {{ default "" .Values.externalRedis.username | quote }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "snippet.redis.password.secret.name" . }}
      key: {{ include "snippet.redis.password.secret.key" . | quote}}
{{- if and (not .Values.redis.enabled) .Values.externalRedis.ssl_options.enabled }}
- name: REDIS_USE_SSL
  value: "true"
{{- with .Values.externalRedis.ssl_options.ca_certs }}
- name: REDIS_SSL_CA_CERTS
  value: {{ . | quote }}
{{- end }}
{{- with .Values.externalRedis.ssl_options.certfile }}
- name: REDIS_SSL_CERTFILE
  value: {{ . | quote }}
{{- end }}
{{- with .Values.externalRedis.ssl_options.keyfile }}
- name: REDIS_SSL_KEYFILE
  value: {{ . | quote }}
{{- end }}
{{- with .Values.externalRedis.ssl_options.cert_reqs }}
- name: REDIS_SSL_CERT_REQS
  value: {{ . | quote }}
{{- end }}
{{- end }}
{{- end }}
