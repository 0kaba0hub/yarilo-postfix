{{/*
Mail domains: mail.domain + extraDomains (if set).
*/}}
{{- define "yarilo-postfix.mailDomains" -}}
{{- if .Values.mail.extraDomains -}}
{{ .Values.mail.domain }} {{ .Values.mail.extraDomains }}
{{- else -}}
{{ .Values.mail.domain }}
{{- end -}}
{{- end -}}

{{/*
TLS volume mount — no-op when secretName is empty.
*/}}
{{- define "yarilo-postfix.tlsMount" -}}
{{- if . -}}
- name: tls
  mountPath: /etc/postfix/tls
  readOnly: true
{{- end -}}
{{- end -}}

{{/*
TLS volume — no-op when secretName is empty.
*/}}
{{- define "yarilo-postfix.tlsVolume" -}}
{{- if . -}}
- name: tls
  secret:
    secretName: {{ . }}
    defaultMode: 0440
{{- end -}}
{{- end -}}

{{/*
DKIM volume mount — no-op when secretName is empty.
*/}}
{{- define "yarilo-postfix.dkimMount" -}}
{{- if . -}}
- name: dkim
  mountPath: /etc/rspamd/dkim
  readOnly: true
{{- end -}}
{{- end -}}

{{/*
DKIM volume — no-op when secretName is empty.
*/}}
{{- define "yarilo-postfix.dkimVolume" -}}
{{- if . -}}
- name: dkim
  secret:
    secretName: {{ . }}
    defaultMode: 0440
{{- end -}}
{{- end -}}
