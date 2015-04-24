# coding: utf-8
#
require File.expand_path '../../spec_helper', __FILE__

describe 'Cascading DELETEs' do

  def afnetworking
    Domain.pods.where(name: 'AFNetworking').first
  end
  
  def afnetworking_versions
    Domain.versions.where(pod_id: afnetworking.id).all
  end
  
  describe 'versions' do
    it 'has existing versions' do
      afnetworking_versions.size.should == 36
    end

    it 'deletes all associated versions' do
      Domain.pods.delete.where(name: afnetworking.name).kick

      afnetworking_versions.size.should == 0
    end
  end
  
end