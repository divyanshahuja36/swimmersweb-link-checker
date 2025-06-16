#!/bin/bash

mkdir -p reports/json
mkdir -p reports/html

# Prepare CSV
csv_file="reports/lighthouse_summary.csv"
echo "URL,Performance,Accessibility,BestPractices,SEO,TimeToInteractive" > "$csv_file"

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

  # Generate reports in both JSON and HTML formats
  lighthouse "$url" \
    --output html \
    --output-path "reports/html/${name}.html" \
    --output json \
    --output-path "reports/json/${name}.json" \
    --chrome-flags="--headless"

  # Extract scores from JSON using jq
  if [ -f "reports/json/${name}.json" ]; then
    performance=$(jq '.categories.performance.score * 100' "reports/json/${name}.json")
    accessibility=$(jq '.categories.accessibility.score * 100' "reports/json/${name}.json")
    best_practices=$(jq '.categories["best-practices"].score * 100' "reports/json/${name}.json")
    seo=$(jq '.categories.seo.score * 100' "reports/json/${name}.json")
    tti=$(jq '.audits["interactive"].displayValue' "reports/json/${name}.json" | tr -d '"')

    echo "$url,$performance,$accessibility,$best_practices,$seo,$tti" >> "$csv_file"
  fi
done

# Zip all reports
zip -r lighthouse_reports.zip reports/
