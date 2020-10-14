#!/usr/bin/env ruby
# In dev run like: docker run --env GITHUB_TOKEN $(docker build -q -f Dockerfile .)

require "octokit"
require "active_support"
require "active_support/core_ext"

client = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
client.auto_paginate = true
REPO = "kwacky1/all-the-testing"

today = Date.today

milestones = client.milestones(REPO, {state: 'open'})

last_month = (today.prev_month).strftime("%B %Y")
old_milestone = milestones.select{ |m| m.title == last_month }.first
new_month = (today).strftime("%B %Y")
new_milestone = client.create_milestone(REPO, new_month.to_s, {
  due_on: today.end_of_month.strftime("%Y-%m-%dT07:00:00Z")
})

issues = client.issues(REPO, {milestone: old_milestone.number})
issues.each do |issue|
  client.update_issue(REPO, issue.number, {milestone: new_milestone.number})
end

client.update_milestone(REPO, old_milestone.number, {state: "closed"})