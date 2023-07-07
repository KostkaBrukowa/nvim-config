vim.cmd([[
  let g:VM_maps = {}
  let g:VM_default_mappings = 0
  let g:VM_custom_motions  = {'h': 'n', 'j': 'n', 'k': 'e', 'l': 'i', 'I' : '$', 'H' : '^'}
  let g:VM_maps['Find Under']                  = '<C-d>'
  let g:VM_maps['Find Subword Under']          = '<C-d>'
  let g:VM_maps["Add Cursor Down"]             = '<C-n>'
  let g:VM_maps["Add Cursor Up"]               = '<C-e>'

  let g:VM_maps['I'] = '$'
  let g:VM_maps['H'] = '^'
]])
