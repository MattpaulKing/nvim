-- NOTE: replace all instances of current word
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- NOTE: move splits
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Move to top split" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Move to right split" })
