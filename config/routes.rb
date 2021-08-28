Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :user
      resources :people
      resources :location
      resources :npid
      resources :merge
    end
  end

  post "v1/register", to: "api/v1/user#register"
  post "v1/login", to: "api/v1/user#login"
  post "v1/add_user", to: "api/v1/user#add_user"
  post "v1/verify_token/", to: "api/v1/user#verify_token"

  #people controller routes
  post "v1/add_person", to: "api/v1/people_details#create"
  post "v1/search_by_name_and_gender", to: "api/v1/people_details#search_by_name_and_gender"
  post "v1/search_by_npid", to: "api/v1/people_details#search_by_npid"
  post "v1/search_by_doc_id", to: "api/v1/people_details#search_by_doc_id"
  post "v1/search_by_attributes", to: "api/v1/people#search_by_attributes"
  post "v1/potential_duplicates", to: "api/v1/people#potential_duplicates"
  post "v1/merge_people", to: "api/v1/people_details#merge_people"
  post "v1/assign_npid", to: "api/v1/people#assign_npid"
  post "v1/update_person/", to: "api/v1/people_details#update_person"
  delete "v1/void_person/:person_uuid", to: "api/v1/people_details#void"

  #npid controller routes
  post "v1/assign_npids", to: "api/v1/npid#assign_npids"

  #location controller routes
  post "v1/find_location", to: "api/v1/location#find"
  post "v1/list_locations", to: "api/v1/location#list_assigned_locations"

  post "v1/npids_assigned", to: "api/v1/location#npids_assigned"
  post "v1/total_allocated_npids", to: "api/v1/location#total_allocated_npids"
  post "v1/get_locations", to: "api/v1/location#get_locations"

  #footprint
  post "v1/update_footprint/", to: "api/v1/footprint#update_footprint"

  #merging
  post "v1/merge_people", to: "api/v1/merge#merge"
  post "v1/reassign_npid", to: "api/v1/people_details#reassign_npid"

  post "v1/search/people", to: "api/v1/people_match#get"
  get   "v1/get_regions", to: "api/v1/location#get_regions"
  get   "v1/get_regional_stats", to: "api/v1/location#regional_stats"
  post  "/v1/update_location_field", to: "api/v1/location#update_location_field"

  #dashboard links
  get   "v1/new_ids_assigned", to: "api/v1/people#total_assigned"
  get   "v1/foot_print_stats", to: "api/v1/people#client_movements"
  get   "v1/system_info", to: "api/v1/system#info"
  get   "v1/cum_total_assigned", to: "api/v1/people#cum_total_assigned"
  get   "v1/sync_info", to: "api/v1/location#sync_info"
  get   "v1/footprints", to: "api/v1/footprint#by_category"

  #sync links
  get   'v1/person_changes_new', to: 'api/v1/sync#pull_updates_new'
  get   'v1/person_changes_updates', to: 'api/v1/sync#pull_updates'
  post  'v1/push_changes_new', to: 'api/v1/sync#pushed_updates_new'
  post  'v1/push_changes_updates', to: 'api/v1/sync#pushed_updates'
  get   'v1/pull_npids', to: 'api/v1/sync#pull_npids'

  #config routes
  put 'v1/configs', to: 'api/v1/configs#update'

  root to: "api/v1/user#index"
end
