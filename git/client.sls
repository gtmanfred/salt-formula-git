{%- from "git/map.jinja" import client with context %}
{%- from "linux/map.jinja" import system with context %}

{%- if client.enabled %}

include:
- linux.system.user

git_packages:
  pkg.installed:
  - names: {{ client.pkgs|tojson }}

{%- for user in client.user %}

set_git_{{ user.user.name|tojson }}_param_username:
  git.config_set:
  - user: {{ user.user.name|tojson }}
  - name: user.name
  - value: "{{ user.user.get('full_name', user.user.name)|tojson }}"
  - global: True
  - require:
    - user: system_user_{{ user.user.name|tojson }}

{%- if user.user.email is defined %}

set_git_{{ user.user.name|tojson }}_param_email:
  git.config_set:
  - user: {{ user.user.name|tojson }}
  - name: user.email
  - value: "{{ user.user.email|tojson }}"
  - global: True
  - require:
    - user: system_user_{{ user.user.name|tojson }}

{%- endif %}

{%- if client.disable_ssl_verification == True %}

set_git_ssl_verification_off:
  git.config_set:
  - user: {{ user.user.name|tojson }}
  - name: http.sslVerify
  - value: "false"
  - global: True
  - require:
    - user: system_user_{{ user.user.name|tojson }}

{%- endif %}

{%- endfor %}

{%- endif %}
