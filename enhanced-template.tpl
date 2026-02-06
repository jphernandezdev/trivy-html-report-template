<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
{{- if . }}
    <title>Trivy Report - {{ now }}</title>
    <style>
        :root {
            --bg-primary: #1a1a1a;
            --bg-secondary: #2d2d2d;
            --text-primary: #e0e0e0;
            --text-secondary: #a0a0a0;
            --border-color: #404040;
            --accent-color: #3498db;
            --severity-low-bg: rgba(95, 187, 49, 0.2);
            --severity-medium-bg: rgba(233, 198, 0, 0.2);
            --severity-high-bg: rgba(255, 136, 0, 0.2);
            --severity-critical-bg: rgba(228, 0, 0, 0.2);
            --severity-unknown-bg: rgba(116, 116, 116, 0.2);
            --severity-low-text: #5fbb31;
            --severity-medium-text: #e9c600;
            --severity-high-text: #ff8800;
            --severity-critical-text: #ff4444;
            --severity-unknown-text: #747474;
        }

        [data-theme="light"] {
            --bg-primary: #ffffff;
            --bg-secondary: #f5f5f5;
            --text-primary: #1a1a1a;
            --text-secondary: #666666;
            --border-color: #e0e0e0;
            --accent-color: #2980b9;
            --severity-low-bg: rgba(95, 187, 49, 0.1);
            --severity-medium-bg: rgba(233, 198, 0, 0.1);
            --severity-high-bg: rgba(255, 136, 0, 0.1);
            --severity-critical-bg: rgba(228, 0, 0, 0.1);
            --severity-unknown-bg: rgba(116, 116, 116, 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        }

        body {
            background-color: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.6;
            padding: 2rem;
            transition: background-color 0.3s ease;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem;
            background-color: var(--bg-secondary);
            border-radius: 8px;
        }

        .controls {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        button {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 4px;
            background-color: var(--bg-primary);
            color: var(--text-primary);
            cursor: pointer;
            transition: opacity 0.2s ease;
        }

        button:hover {
            opacity: 0.8;
        }

        .theme-toggle {
            width: 48px;
            height: 24px;
            border-radius: 12px;
            background-color: var(--bg-primary);
            position: relative;
            cursor: pointer;
        }

        .theme-toggle::before {
            content: '';
            position: absolute;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background-color: var(--text-primary);
            top: 2px;
            left: 2px;
            transition: transform 0.3s ease;
        }

        [data-theme="light"] .theme-toggle::before {
            transform: translateX(24px);
        }

        .target-section {
            margin-bottom: 2rem;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            overflow: hidden;
        }

        .target-header {
            padding: 1rem;
            background-color: var(--bg-secondary);
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .target-content {
            display: none;
            padding: 0rem;
        }

        .target-content.expanded {
            display: block;
        }

        .target-content p {
            padding: 1rem;
        }

        .target-content p:first-child {
            padding-top: 1rem !important;
        }

        .target-content p:last-child {
            padding-bottom: 1rem !important;
        }

        .target-content p + p {
            padding-top: 0rem;
        }

        .filter-empty {
            padding: 1rem;
            color: var(--text-secondary);
            font-style: italic;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }

        th, td {
            padding: 0.75rem;
            text-align: left;
            border: 1px solid var(--border-color);
        }

        th {
            background-color: var(--bg-secondary);
            font-weight: 600;
        }

        .align-center {
            text-align: center;
        }

        .nowrap {
            white-space: nowrap;
        }

        .severity {
            text-align: center;
            font-weight: bold;
            border-radius: 4px;
            padding: 0.25rem 0.5rem;
        }

        .severity-LOW { background-color: var(--severity-low-bg); color: var(--severity-low-text); }
        .severity-MEDIUM { background-color: var(--severity-medium-bg); color: var(--severity-medium-text); }
        .severity-HIGH { background-color: var(--severity-high-bg); color: var(--severity-high-text); }
        .severity-CRITICAL { background-color: var(--severity-critical-bg); color: var(--severity-critical-text); }
        .severity-UNKNOWN { background-color: var(--severity-unknown-bg); color: var(--severity-unknown-text); }

        .links a {
            display: block;
            color: var(--text-primary);
            text-decoration: none;
            margin: 0.25rem 0;
        }

        .links a:hover {
            text-decoration: underline;
        }

        .links[data-more-links="off"] a:nth-of-type(1n+4) {
            display: none;
        }

        .toggle-more-links {
            display: inline-block;
            margin: 0.5rem 0;
            padding: 0.25rem 0rem;
            color: var(--text-primary);
            border-radius: 4px;
            font-size: 0.85rem;
            cursor: pointer;
            text-decoration: none !important;
            transition: opacity 0.2s ease;
        }

        .toggle-more-links:hover {
            opacity: 0.9;
        }

        .toggle-more-links::after {
            content: ' ▼';
            font-size: 0.8rem;
        }

        .links[data-more-links="on"] .toggle-more-links::after {
            content: ' ▲';
        }

        .global-summary {
            padding: 1rem 0;
            display: flex;
            justify-content: flex-end;
        }
        
        .summary-count {
            display: inline-block;
            margin: 0 0.3rem;
            padding: 0 0.5rem;
            border-radius: 4px;
        }

        .summary-filter {
            border: none;
            cursor: pointer;
            font: inherit;
            transition: transform 0.2s ease, box-shadow 0.2s ease, opacity 0.2s ease;
        }

        .summary-filter:hover {
            transform: translateY(-1px);
            opacity: 0.9;
        }

        .summary-filter.is-active {
            box-shadow: 0 0 0 2px var(--accent-color);
        }

        .summary-filter:focus-visible {
            outline: 2px solid var(--accent-color);
            outline-offset: 2px;
        }

        .is-hidden {
            display: none !important;
        }
        
        .count-CRITICAL { background-color: var(--severity-critical-bg); color: var(--severity-critical-text); }
        .count-HIGH { background-color: var(--severity-high-bg); color: var(--severity-high-text); }
        .count-MEDIUM { background-color: var(--severity-medium-bg); color: var(--severity-medium-text); }
        .count-LOW { background-color: var(--severity-low-bg); color: var(--severity-low-text); }
        .count-UNKNOWN { background-color: var(--severity-unknown-bg); color: var(--severity-unknown-text); }
    </style>
    <script>
        window.onload = function() {
            // Theme toggle
            const themeToggle = document.getElementById('themeToggle');
            const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
            document.documentElement.setAttribute('data-theme', prefersDark ? 'dark' : 'light');

            themeToggle.onclick = function() {
                const currentTheme = document.documentElement.getAttribute('data-theme');
                const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
                document.documentElement.setAttribute('data-theme', newTheme);
            };

            // Section collapse/expand
            document.querySelectorAll('.target-header').forEach(header => {
                header.onclick = function() {
                    const content = this.nextElementSibling;
                    content.classList.toggle('expanded');
                    this.querySelector('.collapse-indicator').textContent = 
                        content.classList.contains('expanded') ? '▼' : '▶';
                };
            });

            // Collapse/Expand all
            document.getElementById('collapseAll').onclick = function() {
                document.querySelectorAll('.target-content').forEach(content => {
                    content.classList.remove('expanded');
                    content.previousElementSibling.querySelector('.collapse-indicator').textContent = '▶';
                });
            };

            document.getElementById('expandAll').onclick = function() {
                document.querySelectorAll('.target-content').forEach(content => {
                    content.classList.add('expanded');
                    content.previousElementSibling.querySelector('.collapse-indicator').textContent = '▼';
                });
            };

            // Links toggle
            document.querySelectorAll('td.links').forEach(function(linkCell) {
                var links = Array.from(linkCell.querySelectorAll('a'));
                links.sort((a, b) => a.href > b.href ? 1 : -1);
                
                if (links.length > 2) {
                    // Remove all links
                    links.forEach(link => link.remove());
                    
                    // Add first 3 links back
                    for (let i = 0; i < 2; i++) {
                        if (links[i]) {
                            linkCell.appendChild(links[i]);
                        }
                    }
                    
                    // Add toggle button
                    const toggleLink = document.createElement('a');
                    toggleLink.innerText = `Show ${links.length - 2} more links`;
                    toggleLink.className = "toggle-more-links";
                    toggleLink.onclick = function(e) {
                        e.preventDefault();
                        const expanded = linkCell.getAttribute("data-more-links") === "on";
                        linkCell.setAttribute("data-more-links", expanded ? "off" : "on");
                        this.innerText = expanded ? `Show ${links.length - 2} more links` : "Show fewer links";
                    };
                    linkCell.appendChild(toggleLink);
                    
                    // Add remaining links
                    for (let i = 2; i < links.length; i++) {
                        linkCell.appendChild(links[i]);
                    }
                }
            });

            const globalFilter = new Set();
            const sectionFilters = new Map();

            const applyFilters = () => {
                const globalActive = globalFilter.size > 0;

                document.querySelectorAll('.target-section').forEach(section => {
                    const sectionId = section.dataset.sectionId;
                    const activeSet = globalActive
                        ? globalFilter
                        : (sectionFilters.get(sectionId) || new Set());

                    const rows = Array.from(section.querySelectorAll('tr[data-severity]'));
                    let visibleCount = 0;

                    rows.forEach(row => {
                        const severity = row.dataset.severity;
                        const visible = activeSet.size === 0 || activeSet.has(severity);
                        row.style.display = visible ? '' : 'none';
                        if (visible) {
                            visibleCount += 1;
                        }
                    });

                    section.querySelectorAll('table').forEach(table => {
                        const tableRows = Array.from(table.querySelectorAll('tr[data-severity]'));
                        const tableVisible = activeSet.size === 0 || tableRows.some(row => row.style.display !== 'none');
                        table.classList.toggle('is-hidden', !tableVisible);
                    });

                    const emptyMessage = section.querySelector('.filter-empty');
                    if (emptyMessage) {
                        emptyMessage.classList.toggle('is-hidden', !(activeSet.size > 0 && visibleCount === 0));
                    }
                });
            };

            document.querySelectorAll('.summary-filter').forEach(button => {
                button.addEventListener('click', event => {
                    event.stopPropagation();
                    const severity = button.dataset.severity;
                    const scope = button.dataset.scope;

                    if (scope === 'global') {
                        if (globalFilter.has(severity)) {
                            globalFilter.delete(severity);
                            button.classList.remove('is-active');
                        } else {
                            globalFilter.add(severity);
                            button.classList.add('is-active');
                        }
                    } else {
                        const sectionId = button.dataset.sectionId;
                        if (!sectionFilters.has(sectionId)) {
                            sectionFilters.set(sectionId, new Set());
                        }
                        const sectionSet = sectionFilters.get(sectionId);
                        if (sectionSet.has(severity)) {
                            sectionSet.delete(severity);
                            button.classList.remove('is-active');
                        } else {
                            sectionSet.add(severity);
                            button.classList.add('is-active');
                        }
                    }

                    applyFilters();
                });
            });
        };
    </script>
</head>
<body>
    <div class="header">
        <h1>Trivy Report - {{ now }}</h1>
        <div class="controls">
            <button id="collapseAll">Collapse All</button>
            <button id="expandAll">Expand All</button>
            <div id="themeToggle" class="theme-toggle" title="Toggle theme"></div>
        </div>
    </div>

    {{- $totalCritical := 0 }}
    {{- $totalHigh := 0 }}
    {{- $totalMedium := 0 }}
    {{- $totalLow := 0 }}
    {{- $totalUnknown := 0 }}
    
    {{/* First pass to calculate global totals */}}
    {{- range . }}
        {{- range .Vulnerabilities }}
            {{- if eq .Vulnerability.Severity "CRITICAL" }}
                {{- $totalCritical = add $totalCritical 1 }}
            {{- else if eq .Vulnerability.Severity "HIGH" }}
                {{- $totalHigh = add $totalHigh 1 }}
            {{- else if eq .Vulnerability.Severity "MEDIUM" }}
                {{- $totalMedium = add $totalMedium 1 }}
            {{- else if eq .Vulnerability.Severity "LOW" }}
                {{- $totalLow = add $totalLow 1 }}
            {{- else }}
                {{- $totalUnknown = add $totalUnknown 1 }}
            {{- end }}
        {{- end }}
    {{- end }}
    
    {{- $globalTotal := add (add (add (add $totalCritical $totalHigh) $totalMedium) $totalLow) $totalUnknown }}
    <div class="global-summary">
        <div><strong>Total:</strong> {{ $globalTotal }} </div>
        <div><button class="summary-count summary-filter count-UNKNOWN" data-severity="UNKNOWN" data-scope="global">UNKNOWN: {{ $totalUnknown }}</button></div>
        <div><button class="summary-count summary-filter count-LOW" data-severity="LOW" data-scope="global">LOW: {{ $totalLow }}</button></div>
        <div><button class="summary-count summary-filter count-MEDIUM" data-severity="MEDIUM" data-scope="global">MEDIUM: {{ $totalMedium }}</button></div>
        <div><button class="summary-count summary-filter count-HIGH" data-severity="HIGH" data-scope="global">HIGH: {{ $totalHigh }}</button></div>
        <div><button class="summary-count summary-filter count-CRITICAL" data-severity="CRITICAL" data-scope="global">CRITICAL: {{ $totalCritical }}</button></div>
    </div>

    {{- range $index, $target := . }}
        {{- $critical := 0 }}
        {{- $high := 0 }}
        {{- $medium := 0 }}
        {{- $low := 0 }}
        {{- $unknown := 0 }}
        {{- range $target.Vulnerabilities }}
            {{- if eq .Vulnerability.Severity "CRITICAL" }}
                {{- $critical = add $critical 1 }}
            {{- else if eq .Vulnerability.Severity "HIGH" }}
                {{- $high = add $high 1 }}
            {{- else if eq .Vulnerability.Severity "MEDIUM" }}
                {{- $medium = add $medium 1 }}
            {{- else if eq .Vulnerability.Severity "LOW" }}
                {{- $low = add $low 1 }}
            {{- else }}
                {{- $unknown = add $unknown 1 }}
            {{- end }}
        {{- end }}
        {{- $sectionTotal := add (add (add (add $critical $high) $medium) $low) $unknown }}
    <div class="target-section" data-section-id="section-{{ $index }}">
        <div class="target-header">
            <div>
                <strong>Type:</strong> {{ $target.Type | toString | escapeXML }} | 
                <strong>Target:</strong> {{ $target.Target | toString | escapeXML }} | 
                <strong>Total:</strong> {{ $sectionTotal }} 
                <button class="summary-count summary-filter count-UNKNOWN" data-severity="UNKNOWN" data-scope="section" data-section-id="section-{{ $index }}">UNKNOWN: {{ $unknown }}</button>
                <button class="summary-count summary-filter count-LOW" data-severity="LOW" data-scope="section" data-section-id="section-{{ $index }}">LOW: {{ $low }}</button>
                <button class="summary-count summary-filter count-MEDIUM" data-severity="MEDIUM" data-scope="section" data-section-id="section-{{ $index }}">MEDIUM: {{ $medium }}</button>
                <button class="summary-count summary-filter count-HIGH" data-severity="HIGH" data-scope="section" data-section-id="section-{{ $index }}">HIGH: {{ $high }}</button>
                <button class="summary-count summary-filter count-CRITICAL" data-severity="CRITICAL" data-scope="section" data-section-id="section-{{ $index }}">CRITICAL: {{ $critical }}</button>
            </div>
            <span class="collapse-indicator">▶</span>
        </div>
        <div class="target-content">
            {{- if (eq (len $target.Vulnerabilities) 0) }}
            <p>No Vulnerabilities found</p>
            {{- else }}
            <table>
                <tr>
                    <th>Package</th>
                    <th>Vulnerability ID</th>
                    <th>Severity</th>
                    <th>Installed Version</th>
                    <th>Fixed Version</th>
                    <th>Links</th>
                </tr>
                {{- range $target.Vulnerabilities }}
                <tr data-severity="{{ escapeXML .Vulnerability.Severity }}">
                    <td class="nowrap"><strong>{{ escapeXML .PkgName }}</strong></td>
                    <td class="nowrap">{{ escapeXML .VulnerabilityID }}</td>
                    <td class="align-center"><span class="severity severity-{{ escapeXML .Vulnerability.Severity }}">{{ escapeXML .Vulnerability.Severity }}</span></td>
                    <td><strong>{{ escapeXML .InstalledVersion }}</strong></td>
                    <td>{{ escapeXML .FixedVersion }}</td>
                    <td class="links" data-more-links="off">
                        {{- range .Vulnerability.References }}
                        <a href={{ escapeXML . | printf "%q" }} target="_blank">{{ escapeXML . }}</a>
                        {{- end }}
                    </td>
                </tr>
                {{- end }}
            </table>
            {{- end }}

            {{- if (eq (len $target.Misconfigurations ) 0) }}
            <p>No Misconfigurations found</p>
            {{- else }}
            <table>
                <tr>
                    <th>Type</th>
                    <th>Misconf ID</th>
                    <th>Check</th>
                    <th>Severity</th>
                    <th>Message</th>
                </tr>
                {{- range $target.Misconfigurations }}
                <tr data-severity="{{ escapeXML .Severity }}">
                    <td>{{ escapeXML .Type }}</td>
                    <td>{{ escapeXML .ID }}</td>
                    <td>{{ escapeXML .Title }}</td>
                    <td><span class="severity severity-{{ escapeXML .Severity }}">{{ escapeXML .Severity }}</span></td>
                    <td style="white-space: normal;">
                        {{ escapeXML .Message }}
                        <br>
                        <a href={{ escapeXML .PrimaryURL | printf "%q" }} target="_blank">{{ escapeXML .PrimaryURL }}</a>
                    </td>
                </tr>
                {{- end }}
            </table>
            {{- end }}
            <p class="filter-empty is-hidden">No matching items for the selected severity.</p>
        </div>
    </div>
    {{- end }}
{{- else }}
    </head>
    <body>
        <h1>Trivy Returned Empty Report</h1>
{{- end }}
</body>
</html>
