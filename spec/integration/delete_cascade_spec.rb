# coding: utf-8
#
require File.expand_path '../../spec_helper', __FILE__

describe 'Cascading DELETEs' do

  # A cached pod.
  #
  def afnetworking
    @afnetworking ||= Domain.pods.where(name: 'AFNetworking').first
  end

  # A cached version.
  #
  def afnetworking_version
    @afnetworking_version ||= Domain.versions.where(pod_id: afnetworking.id).first
  end

  # A cached commit.
  #
  def afnetworking_commit
    @afnetworking_commit ||= Domain.commits.where(pod_version_id: afnetworking_version.id).first
  end

  # Freshly loaded pods.
  #
  def afnetworking_pods
    Domain.pods.where(id: afnetworking.id).all
  end

  # Freshly loaded versions.
  #
  def afnetworking_versions
    Domain.versions.where(pod_id: afnetworking.id).all
  end

  # Freshly loaded commits.
  #
  def afnetworking_commits
    Domain.commits.where(pod_version_id: afnetworking_version.id).all
  end

  # Delete the pod.
  #
  def delete_afnetworking
    Domain.pods.delete.where(id: afnetworking.id).kick
  end

  describe 'afnetworking' do
    describe 'before migrating' do
      it 'has an existing pod' do
        afnetworking.id.should == 9
      end

      it 'has existing versions' do
        afnetworking_versions.size.should == 41 # Versions of the pod.
      end
  
      it 'has existing commits' do
        afnetworking_commits.size.should == 7 # Commits of the first version.
      end
    
      it 'cannot delete the pod' do
        lambda { delete_afnetworking }.
        should.raise(PG::ForeignKeyViolation)
      end
    end
  
    describe 'after migrating' do
      before do
        puts "Migrating test database."
        `RACK_ENV=test bundle exec rake db:migrate`
      
        delete_afnetworking
      end
    
      it 'has no pod' do
        afnetworking_pods.size.should == 0
      end
    
      it 'has no more associated versions' do
        afnetworking_versions.size.should == 0
      end
    
      it 'has no more associated commits' do
        afnetworking_commits.size.should == 0
      end
    end
  end
  
end