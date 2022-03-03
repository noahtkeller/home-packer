control 'package-01' do
  impact 1.0
  title 'CIS: Additional process hardening'
  desc 'Apache2 is installed'
  describe package 'apache2' do
    it { should be_installed }
  end
end
