local M = {}

-- Configuration
M.default_base_branch = "origin/master"
M.base_branch = M.default_base_branch

-- Set custom base branch
function M.set_base_branch(branch)
    M.base_branch = branch
end

-- Reset to default base branch
function M.reset_base_branch()
    M.base_branch = M.default_base_branch
end

-- Get current branch name
local function get_current_branch()
    local handle = io.popen("git branch --show-current 2>/dev/null")
    if not handle then
        return nil
    end
    local branch = handle:read("*a")
    handle:close()
    return branch:gsub("%s+", "")
end

-- Get remote tracking branch
local function get_remote_branch()
    local handle = io.popen("git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null")
    if not handle then
        return nil
    end
    local remote_branch = handle:read("*a")
    handle:close()
    return remote_branch:gsub("%s+", "")
end

-- Get repository info (owner/repo)
local function get_repo_info()
    local handle = io.popen("git remote get-url origin 2>/dev/null")
    if not handle then
        return nil, nil
    end
    local url = handle:read("*a")
    handle:close()

    -- Parse GitHub URL (supports both HTTPS and SSH)
    local owner, repo = url:match("github%.com[:/](.+)/(.+)%.git")
    if not owner or not repo then
        owner, repo = url:match("github%.com[:/](.+)/(.+)")
    end

    if repo then
        repo = repo:gsub("%s+", "")
    end

    return owner, repo
end

-- Check if PR exists for current branch using GitHub CLI
local function check_pr_exists()
    local current_branch = get_current_branch()
    if not current_branch or current_branch == "" then
        return false, nil
    end

    -- Use gh CLI to check for PR
    local handle = io.popen(string.format("gh pr view %s --json url,isDraft 2>/dev/null", current_branch))
    if not handle then
        return false, nil
    end

    local output = handle:read("*a")
    local exit_code = handle:close()

    if output and output ~= "" and exit_code then
        local pr_data = vim.json.decode(output)
        return true, pr_data
    end

    return false, nil
end

-- Open PR in browser
local function open_pr_in_browser(pr_url)
    if not pr_url then
        vim.notify("No PR URL available", vim.log.levels.ERROR)
        return
    end

    -- Use system open command based on OS
    local open_cmd = vim.fn.has("mac") == 1 and "open" or "xdg-open"
    vim.fn.system(string.format("%s '%s'", open_cmd, pr_url))
    vim.notify("Opening PR in browser: " .. pr_url, vim.log.levels.INFO)
end

-- Create PR using gh CLI
local function create_pr(is_draft)
    local current_branch = get_current_branch()
    local base_branch = M.base_branch:gsub("^origin/", "")

    vim.notify(string.format("Creating %sPR: %s -> %s", is_draft and "draft " or "", current_branch, base_branch),
        vim.log.levels.INFO)

    -- Use gh CLI to create PR with --fill-first to auto-populate title only
    local draft_flag = is_draft and "--draft" or ""
    local cmd = string.format("gh pr create --base %s %s --fill-first", base_branch, draft_flag)

    -- Run in a terminal so user can see the output
    vim.cmd(string.format("terminal %s", cmd))
end

-- Main function to check and prompt for PR actions
function M.post_push_pr_check()
    -- Small delay to ensure push is complete
    vim.defer_fn(function()
        local pr_exists, pr_data = check_pr_exists()

        if pr_exists and pr_data then
            -- PR exists - offer to open it
            local pr_status = pr_data.isDraft and " (Draft)" or ""
            vim.ui.select(
                { "Open PR in browser", "Cancel" },
                {
                    prompt = string.format("PR exists%s: %s", pr_status, pr_data.url),
                },
                function(choice)
                    if choice == "Open PR in browser" then
                        open_pr_in_browser(pr_data.url)
                    end
                end
            )
        else
            -- No PR exists - offer to create one
            local current_branch = get_current_branch()
            if not current_branch or current_branch == "" then
                return
            end

            local base_display = M.base_branch:gsub("^origin/", "")
            vim.ui.select(
                { "Open PR", "Open Draft PR", "Cancel" },
                {
                    prompt = string.format("No PR found for '%s'. Create PR to '%s'?", current_branch, base_display),
                },
                function(choice)
                    if choice == "Open PR" then
                        create_pr(false)
                    elseif choice == "Open Draft PR" then
                        create_pr(true)
                    end
                end
            )
        end
    end, 500)
end

return M
