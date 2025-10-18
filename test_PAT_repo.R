# --- Load packages ---
library(gert)
library(credentials)

# --- Step 1: Fetch the latest remote references ---
git_fetch("origin")

# --- Step 2: Identify remote default branch ---
refs <- git_remote_ls("origin")
def <- if (any(refs$ref == "refs/heads/main")) "main" else if (any(refs$ref == "refs/heads/master")) "master" else NA
cat("== Default branch detected:", def, "==\n")

# --- Step 3: Create local branch from remote if needed ---
bl <- git_branch_list()
if (!def %in% bl$name) {
  cat("== Creating local branch from origin/", def, "==\n", sep = "")
  git_branch_create(def, paste0("origin/", def))
}

# --- Step 4: Check out the branch and set upstream tracking ---
git_branch_checkout(def)
git_branch_set_upstream(name = def, remote = "origin", upstream = def)

# --- Step 5: Pull to sync with GitHub ---
cat("== git_pull ==\n")
print(tryCatch(git_pull(), error = function(e) e))

# --- Step 6: Stage and commit any local changes (like your new file) ---
cat("== git_add ==\n")
print(tryCatch(git_add(dir(all.files = TRUE)), error = function(e) e))

cat("== git_commit_all ==\n")
print(tryCatch(git_commit_all("my first commit"), error = function(e) e))

# --- Step 7: Authenticate and push changes back to GitHub ---
cat("== git_push ==\n")
credentials::set_github_pat()   # enter PAT in password field if prompted
print(tryCatch(git_push(), error = function(e) e))

# --- Step 8: Confirm repo state for Canvas submission ---
cat("\n== git_info ==\n"); print(git_info())
cat("\n== git_branch_list ==\n"); print(git_branch_list())
cat("\n== git_remote_list ==\n"); print(git_remote_list())
