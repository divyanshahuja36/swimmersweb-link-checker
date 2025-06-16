#!/bin/bash
mkdir -p reports

urls=(
  "https://swimmersweb.com/"
  "https://swimmersweb.com/register"
  "https://swimmersweb.com/login"
  "https://swimmersweb.com/favorites"
  "https://swimmersweb.com/profile"
  "https://swimmersweb.com/privacy-policy"
  "https://swimmersweb.com/terms-conditions"
  "https://swimmersweb.com/contact"
  "https://swimmersweb.com/services"
  "https://swimmersweb.com/swimmer-search"
  "https://swimmersweb.com/swimmer-report"
  "https://swimmersweb.com/team-search"
  "https://swimmersweb.com/team-member-search"
  "https://swimmersweb.com/meet-search"
  "https://swimmersweb.com/meet-detail"
  "https://swimmersweb.com/motivational-time"
  "https://swimmersweb.com/swim-compare"
  "https://swimmersweb.com/tools"
  "https://swimmersweb.com/upcoming-meet"
  "https://swimmersweb.com/lap-timer"
)

for url in "${urls[@]}"; do
  name=$(echo "$url" | sed 's|https://||;s|/|_|g')
  lighthouse "$url" --output html --output-path "reports/${name}.html" --chrome-flags="--headless"
done

zip -r lighthouse_reports.zip reports/
