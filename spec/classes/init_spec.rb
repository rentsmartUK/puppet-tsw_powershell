require 'spec_helper'
describe 'tsw_powershell' do
  context 'with default values for all parameters' do
    it { should contain_class('tsw_powershell') }
  end
end
