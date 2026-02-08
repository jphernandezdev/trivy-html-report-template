# 🌟 Enhanced Trivy HTML Template

🚀 **A modern, feature-rich HTML report template for [Trivy](https://github.com/aquasecurity/trivy)!**

Trivy is a powerful vulnerability scanner for containers, Kubernetes, and code repositories. This repository provides a significantly improved HTML report template that enhances readability, usability, and interactivity.

## ✨ Features

- 🎨 **Modern and sleek design** - Upgraded UI for better readability and aesthetics.
- 📊 **Total vulnerability summary** - Get a quick overview of all detected vulnerabilities.
- 📑 **Section-wise breakdown** - Easily navigate through categorized vulnerabilities.
- 🔽 **Collapsible nodes** - Expand or collapse all vulnerability sections with a single click.
- 🧭 **Severity filters** - Filter globally or per section by vulnerability severity.
- 🌗 **Dark mode & Light mode support** - Seamless viewing experience in both themes.

## 📷 Screenshots

![Enhanced Trivy Report](images/enhanced_trivy_report_demo.gif)

## 📦 Installation & Usage

1. Install Trivy (if not already installed):
   ```sh
   brew install aquasecurity/trivy/trivy  # macOS
   sudo apt install trivy                 # Debian/Ubuntu
   ```
   More installation methods: [Trivy Docs](https://aquasecurity.github.io/trivy/v0.45/getting-started/installation/)

2. **Configure the template path using an environment variable** *(Recommended)*:
   
   To avoid copying the template to each working directory, store it in a centralized location (e.g., `~/trivy/templates/`). Then, set an environment variable:
   
   ```sh
   export TRIVY_HTML_TEMPLATE="@$HOME/trivy/templates/enhanced-template.tpl"
   ```
   
   Add this line to your `~/.bashrc`, `~/.zshrc`, or equivalent shell configuration file for persistence.

4. Run a scan and generate an HTML report using the environment variable:
   
   ```sh
   trivy image --format template --template $TRIVY_HTML_TEMPLATE -o report.html your-image-name
   ```
   
   Alternatively, specify the template path manually:
   
   ```sh
   trivy image --format template --template @/Users/your-user/trivy/templates/enhanced-template.tpl -o report.html your-image-name
   ```

5. Open `report.html` in your browser to explore the enhanced visualization.

## 🚀 Contributing

Contributions are welcome! Feel free to submit a pull request or open an issue.

## 📜 License

This project is licensed under the [MIT License](LICENSE).

## ❤️ Support

If you like this project, consider giving it a ⭐ on GitHub!

---

🔗 **Learn more about Trivy:**
- [Trivy GitHub Repository](https://github.com/aquasecurity/trivy)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
