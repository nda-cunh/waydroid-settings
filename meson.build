project('waydroid-settings', ['c', 'vala'],
  version : '0.1',
  default_options : ['warning_level=3'])

# vapi_dir = meson.current_source_dir() / 'vapi'
# add_project_arguments(['--vapidir', vapi_dir], language: 'vala')

executable('waydroid-settings',
           'main.vala',
           'Window.vala',
           'Settings.vala',
           'Script.vala',
           dependencies : [
              dependency('gtk4'),
              dependency('libadwaita-1'),
              dependency('vte-2.91-gtk4')],
           install : true)
