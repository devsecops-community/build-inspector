require 'fileutils'
require 'zip'
require_relative 'build_inspector'
require_relative 'vagrant_whisperer'

class EvidenceCollector
  def initialize(whisperer:, evidence_name:, verbose: false)
    @whisperer = whisperer
    @evidence_name = evidence_name
    @verbose = verbose
  end

  def collect
    copy_snoopy_log

    zip_name = "#{@evidence_name}.zip"
    remote_zip_path = "#{@whisperer.home}/#{zip_name}"
    zip(BuildInspector::EVIDENCE_PATH, remote_zip_path)
    @whisperer.get_file(remote_zip_path)
    EvidenceCollector.unzip(zip_name, @evidence_name)

    # Call these after unzipping so target directory will exist
    copy_configuration
  end

  private

  def copy_configuration
    dest_file = File.join(@evidence_name, 'config.yml')
    FileUtils.copy_file('config.yml', dest_file)
  end

  def copy_snoopy_log
    @whisperer.run(message: "copying snoopy file WORK") { |c| c << "sudo cp /var/log/snoopy.log #{BuildInspector::EVIDENCE_PATH}" }
  end

  def zip(target, zip_path)
    @whisperer.run { |c| c << "zip -r #{zip_path} #{target} 2>&1 > /dev/null" }
  end

  def self.unzip(zip_path, destination)
    Zip::File.open(zip_path) do |zip|
      zip.each do |entry|
        path = File.join(destination, entry.name)
        FileUtils.mkdir_p(File.dirname(path))
        entry.extract(path) { true } # overwrite destination
      end
    end
  end
end
