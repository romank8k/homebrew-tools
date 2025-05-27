class SemaphoreUi < Formula
  version "2.14.12"
  sha256 "ae883c45ea7266cef9eacd5b5ff5d049e5960624eaf02b9ad9bf4659ff230b63"

  url "https://github.com/semaphoreui/semaphore/releases/download/v#{version}/semaphore_#{version}_darwin_arm64.tar.gz"
  desc "Modern UI and powerful API for Ansible, Terraform, OpenTofu, PowerShell and other DevOps tools."
  homepage "https://semaphoreui.com"

  depends_on "python"

  def install
    # Create a Python virtual environment.
    mkdir_p "#{prefix}/venv"
    system Formula["python"].opt_bin/"python3", "-m", "venv", "#{prefix}/venv"

    # Install Ansible and required dependencies in the virtual environment.
    system "#{prefix}/venv/bin/pip", "install", "ansible"
    system "#{prefix}/venv/bin/pip", "install", "pexpect"

    bin.install "semaphore" => "semaphore"
    chmod 0755, bin/"semaphore"

    # Create a wrapper script for the semaphore binary that activates the virtual environment.
    (bin/"semaphore-ui").write <<~EOS
      #!/bin/bash
      source "#{prefix}/venv/bin/activate"
      "#{bin}/semaphore" "$@"
    EOS

    chmod 0755, bin/"semaphore-ui"

    (var/"semaphore-ui").mkpath

    # For details on the format of the standard input to the setup command, see:
    # https://github.com/semaphoreui/semaphore/blob/develop/deployment/docker/server/server-wrapper
    (etc/"semaphore-ui").mkpath
    config_content = <<~EOS
      2
      #{var}/semaphore-ui/semaphore.db
      #{var}/semaphore-ui

      no
      no
      no
      no
      no
      no
      #{etc}/semaphore-ui
      admin
      Admin
      admin@localhost
      admin
    EOS

    # Write setup config to file (use atomic_write to allow overwriting this file).
    # If macOS fails to run it due to gatekeeper, then it will make it easy to rerun the setup after trusting the binary.
    (etc/"semaphore-ui/setup.json").atomic_write config_content

    # Run semaphore setup with config piped via stdin.
    IO.popen("#{bin}/semaphore setup -", "w") do |io|
      io.write(config_content)
    end
  end

  service do
    run [opt_bin/"semaphore-ui", "server", "--config", "#{etc}/semaphore-ui/config.json"]
    keep_alive true
    log_path "#{var}/log/semaphore-ui.log"
    error_log_path "#{var}/log/semaphore-ui.log"
    working_dir "#{var}/semaphore-ui"
    environment_variables PATH: "#{opt_prefix}/venv/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin}"
  end

  def caveats
    <<~EOS
      Semaphore UI has been installed with a dedicated Python virtual environment
      that includes Ansible.

      Configuration:
        A default configuration file has been created at:
        #{etc}/semaphore-ui/config.json

        The application has been initialized with this configuration during installation.
        In case of errors due to macOS Gatekeeper, re-run the setup after trusting the binary:
        #{bin}/semaphore setup - < #{etc}/semaphore-ui/setup.json

      Data storage:
        Database and temporary files are stored at:
        #{var}/semaphore-ui/

      To start Semaphore UI as a service:
        brew services start semaphore-ui

      To stop the service:
        brew services stop semaphore-ui

      To check the service status:
        brew services list

      To run Semaphore UI manually with the config file:
        semaphore --config #{etc}/semaphore-ui/config.json
    EOS
  end
end
