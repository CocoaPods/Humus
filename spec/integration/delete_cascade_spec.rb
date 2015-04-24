# coding: utf-8
#
require File.expand_path '../../spec_helper', __FILE__

describe 'Cascading DELETEs' do

  def afnetworking
    @afnetworking ||= Domain.pods.where(name: 'AFNetworking').first
  end
  
  def afnetworking_versions
    Domain.versions.where(pod_id: afnetworking.id).all
  end
  
  it 'has existing versions' do
    afnetworking_versions.size.should == 41
  end
  
  describe 'after migrating' do
    before do
      puts "Migrating test database."
      `RACK_ENV=test bundle exec rake db:migrate`
    end
    
    it 'deletes all associated versions' do
      Domain.pods.delete.where(id: afnetworking.id).kick

      afnetworking_versions.size.should == 0
    end
  end
  
end