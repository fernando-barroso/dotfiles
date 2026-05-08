-- VS Code-ish save muscle memory.
vim.keymap.set({ 'i', 'n', 'v' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Easier escape while learning modal editing.
vim.keymap.set('i', 'jk', '<esc>', { desc = 'Exit insert mode' })

-- Keep search results centered while jumping.
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result' })
