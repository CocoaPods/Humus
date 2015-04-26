# coding: utf-8
#
require File.expand_path '../../spec_helper', __FILE__

# A very explicitly formulated spec.
#
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
  
  # Freshly loaded owners pods.
  #
  def afnetworking_owners_pods
    Domain.owners_pods.where(pod_id: afnetworking.id).all
  end
  
  # Freshly loaded github pod metrics.
  #
  def afnetworking_github_pod_metrics
    Domain.github_pod_metrics.where(pod_id: afnetworking.id).all
  end
  
  # Freshly loaded cocoadocs cloc metrics.
  #
  def afnetworking_cocoadocs_cloc_metrics
    Domain.cocoadocs_cloc_metrics.where(pod_id: afnetworking.id).all
  end
  
  # Freshly loaded cocoadocs pod metrics.
  #
  def afnetworking_cocoadocs_pod_metrics
    Domain.cocoadocs_pod_metrics.where(pod_id: afnetworking.id).all
  end

  # Delete the pod.
  #
  def delete_afnetworking
    Domain.pods.delete.where(id: afnetworking.id).kick
  end
  
  Humus.with_snapshot('b008') do
    # Get the test specific database setup.
    #
    require File.expand_path '../../database', __FILE__
    
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
      
        it 'has existing owners pods' do
          afnetworking_owners_pods.size.should == 1
        end
      
        it 'has existing github pod metrics' do
          afnetworking_github_pod_metrics.size.should == 1
        end
      
        it 'has existing cocoadocs cloc metrics' do
          afnetworking_cocoadocs_cloc_metrics.size.should == 3
        end
      
        it 'has existing cocoadocs pod metrics' do
          afnetworking_cocoadocs_pod_metrics.size.should == 1
        end
    
        it 'cannot delete the pod' do
          lambda { delete_afnetworking }.
            should.raise(PG::ForeignKeyViolation)
        end
      end
  
      describe 'after migrating' do
        before do
          # We only need to migrate and delete once.
          #
          unless @migrated
            puts "Migrating test database."
            `RACK_ENV=test bundle exec rake db:migrate`
      
            delete_afnetworking
          end
          @migrated =  true
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
      
        it 'has no more associated owners pods' do
          afnetworking_owners_pods.size.should == 0
        end
      
        it 'has no more associated github pod metrics' do
          afnetworking_github_pod_metrics.size.should == 0
        end
      
        it 'has no more associated cocoadocs cloc metrics' do
          afnetworking_cocoadocs_cloc_metrics.size.should == 0
        end
      
        it 'has no more associated cocoadocs pod metrics' do
          afnetworking_cocoadocs_pod_metrics.size.should == 0
        end
      end
    end
    
  end
  
end