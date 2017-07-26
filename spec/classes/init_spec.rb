require 'spec_helper'
describe 'custom_powershell' do
  context 'with default values for all parameters' do
    it { should contain_class('custom_powershell') }
  end
end
