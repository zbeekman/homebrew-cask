cask 'ibm-cloud-cli' do
  version '0.15.0'
  sha256 'ddd79284a6a9ae567ad9bac445dfa52a0c3b93d903f2d05e5ac204d4bceb4f88'

  # public.dhe.ibm.com/cloud/bluemix/cli/bluemix-cli was verified as official when first introduced to the cask
  url "https://public.dhe.ibm.com/cloud/bluemix/cli/bluemix-cli/#{version}/IBM_Cloud_CLI_#{version}.pkg"
  appcast 'https://github.com/IBM-Cloud/ibm-cloud-cli-release/releases.atom'
  name 'Bluemix-CLI'
  name 'IBM Cloud CLI'
  homepage 'https://clis.ng.bluemix.net/ui/home.html'

  depends_on cask: 'docker'
  depends_on formula: 'kubectl'
  depends_on formula: 'kubernetes-helm'

  pkg "IBM_Cloud_CLI_#{version}.pkg"

  uninstall_postflight do
    if File.exist?('/etc/profile')
      system_command '/usr/bin/sed',
                     args: [
                             '-E',
                             '-i', '.bluemix_uninstall_bak',
                             '-e', '/^### Added by IBM Cloud CLI$/d',
                             '-e', '/^source \/usr\/local\/Bluemix\/bx\/bash_autocomplete$/d',
                             '/etc/profile'
                           ],
                     sudo: true
    end

    if File.exist?("#{ENV['HOME']}/.bashrc")
      system_command '/usr/bin/sed',
                     args: [
                             '-E',
                             '-i', '.bluemix_uninstall_bak',
                             '-e', '/^### Added by IBM Cloud CLI$/d',
                             '-e', '/^source \/usr\/local\/Bluemix\/bx\/bash_autocomplete$/d',
                             "#{ENV['HOME']}/.bashrc"
                           ]
    end

    if File.exist?("#{ENV['HOME']}/.zshrc")
      system_command '/usr/bin/sed',
                     args: [
                             '-E',
                             '-i', '.bluemix_uninstall_bak',
                             '-e', '/^### Added by IBM Cloud CLI$/d',
                             '-e', '/^source \/usr\/local\/Bluemix\/bx\/zsh_autocomplete$/d',
                             "#{ENV['HOME']}/.zshrc"
                           ]
    end
  end

  uninstall pkgutil: 'com.ibm.cloud.cli',
            delete:  [
                       '/usr/local/bin/bluemix',
                       '/usr/local/bin/bx',
                       '/usr/local/bin/bluemix-analytics',
                       '/usr/local/Bluemix',
                       '/usr/local/ibmcloud',
                     ]

  zap trash: '~/.bluemix'

  caveats do
    files_in_usr_local
  end
end
