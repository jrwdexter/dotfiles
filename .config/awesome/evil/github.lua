-- Provides:
-- evil::github::pr
--     pull_requests (table)
local helpers = require("helpers")
local naughty = require("naughty")
local json = require("json")

local update_interval = 60 * 15 -- 15 minutes
local temp_file = "/tmp/awesome-evil-git-prs"
local org = "Monkeyjump-Labs"
local watch_repos = {
  org .. "/cam-fe",
  org .. "/cam-fe-shared",
  org .. "/cam-mobile",
  org .. "/cam-api",
  org .. "/cam-tf",
  org .. "/cam-vis",
  org .. "/dubois-fe",
  org .. "/dubois-be",
  --org .. "/george-apis",
  --org .. "/george-admin-fe",
  --org .. "/george-k8s-cluster",
  --org .. "/george-slackbot",
  --org .. "/fareway-be",
  --org .. "/fareway-cloud",
  --org .. "/fareway-crawler",
  --org .. "/fareway-fe",
  org .. "/agencio-rfp-builder",
}
local repo_filter = ""
for _, v in ipairs(watch_repos) do
  repo_filter = repo_filter .. " repo:" .. v
end
local gh_script = function()
  return [[
    sh -c '
    prs=`gh api graphql -f query='"'"'query {
      search(first: 5, query: "is:pr draft:false is:open ]] .. repo_filter .. [[", type:ISSUE) {
        issueCount,
        edges {
          node {
            ... on PullRequest {
              title,
              createdAt,
              id,
              url
            }
          }
        }
      }
    }'"'"'`
    echo $prs | jq "[.data.search.edges[].node]" ' ]]
end

helpers.remote_watch(gh_script, update_interval, temp_file, function(stdout, stderr, _, code)
  if stdout and not (stdout == "") then
    awesome.emit_signal("evil::github::pr", json.decode(stdout))
  else
    naughty.notification({ title = "Error retrieving github results", message = stderr })
    awesome.emit_signal("evil::github::pr", {})
  end
end, 'evil::github::pr::refresh')
