-- Provides:
-- evil::github::pr
--     pull_requests (table)
local awful = require("awful")
local helpers = require("helpers")
local naughty = require("naughty")
local gears = require("gears")
local json = require("json")

local update_interval = 60 * 15 -- 15 minutes
local temp_file = "/tmp/awesome-evil-git-prs"
org = 'Monkeyjump Labs'
local watch_repos = { 'imaginedeliver-mailroom-be', 'imaginedeliver-mailroom-fe' }
local gh_script = function()
  return [[
    sh -c '
    prs=`gh api graphql -f query='"'"'query {
      search(first: 6, query: "is:pr is:open org:Monkeyjump-Labs", type:ISSUE) {
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
  if stdout and not (stdout == '') then
    awesome.emit_signal("evil::github::pr", json.decode(stdout))
  else
    naughty.notification({title = 'Error retrieving github results', message= stderr})
    awesome.emit_signal("evil:github::pr", {})
  end
end)
