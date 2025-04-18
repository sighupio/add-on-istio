# Maintenance
Instructions for Customizing Istio Dashboards

Follow these steps to download the correct version of an Istio dashboard and update its panel datasources.

## 1. Download the Dashboard

Open your browser and navigate to:https://grafana.com/orgs/istio/dashboards

Find the dashboard version you need.

Click Details → Download JSON.

Save the file as dashboard_name.json.

## 2. Update Panel Datasources

Open dashboard_name.json in a text editor (e.g., VS Code, vim).

Locate every panel's datasource section. Look for or add:
```
"datasource": {
  "type": "prometheus",
  "uid": "${datasource}"
}
```

If the block exists but differs, replace it entirely with the snippet above.

## 3. Verify and Import the Modified Dashboard

In Grafana UI, go to Dashboards → Import.

Upload the modified dashboard_name.json file.

If prompted, select or set the `${datasource}` variable to your Prometheus datasource UID.

Save and explore the imported dashboard.

Note: Ensure your Prometheus datasource in Grafana uses the same uid referenced in the JSON.