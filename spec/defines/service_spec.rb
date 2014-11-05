require 'spec_helper'

describe 'bamboo_agent::service' do

  let(:title) { 'foo' }
  let(:params) do
    {
      :home   => '/tmp',
      :user   => 'jdoe', 
    }
  end

  it do
    attributes = {
      :ensure  => 'file',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0755',
    }

    should contain_file('/etc/init.d/bamboo-agentfoo').with(attributes).with_content(/jdoe -c "\/tmp\/bin\/bamboo-agent.sh /)

    should contain_service('bamboo-agentfoo').with(
      {
         :ensure => 'running',
         :enable => true
      }
    )
  end
end
