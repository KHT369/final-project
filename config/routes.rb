Rails.application.routes.draw do
  # Routes for the Interview resource:

  get("/", { :controller => "interviews", :action => "index" })

  # CREATE
  post("/insert_interview", { :controller => "interviews", :action => "create" })
          
  # READ
  get("/interviews", { :controller => "interviews", :action => "index" })
  
  get("/interviews/:path_id", { :controller => "interviews", :action => "show" })
  
  # UPDATE
  
  post("/modify_interview/:path_id", { :controller => "interviews", :action => "update" })
  
  # DELETE
  get("/delete_interview/:path_id", { :controller => "interviews", :action => "destroy" })

  #------------------------------

  # Routes for the Question resource:

  # CREATE
  post("/insert_question", { :controller => "questions", :action => "create" })
          
  # READ
  get("/questions", { :controller => "questions", :action => "index" })
  
  get("/questions/:path_id", { :controller => "questions", :action => "show" })
  
  # UPDATE
  
  post("/modify_question/:path_id", { :controller => "questions", :action => "update" })
  
  # DELETE
  get("/delete_question/:path_id", { :controller => "questions", :action => "destroy" })

  #------------------------------

  # Routes for the Topic resource:

  # CREATE
  post("/insert_topic", { :controller => "topics", :action => "create" })
          
  # READ
  get("/topics", { :controller => "topics", :action => "index" })
  
  get("/topics/:path_id", { :controller => "topics", :action => "show" })
  
  # UPDATE
  
  post("/modify_topic/:path_id", { :controller => "topics", :action => "update" })
  
  # DELETE
  get("/delete_topic/:path_id", { :controller => "topics", :action => "destroy" })

  #------------------------------

  # Routes for the Course resource:

  # CREATE
  post("/insert_course", { :controller => "courses", :action => "create" })
          
  # READ
  get("/courses", { :controller => "courses", :action => "index" })
  
  get("/courses/:path_id", { :controller => "courses", :action => "show" })
  
  # UPDATE
  
  post("/modify_course/:path_id", { :controller => "courses", :action => "update" })
  
  # DELETE
  get("/delete_course/:path_id", { :controller => "courses", :action => "destroy" })

  #------------------------------

  # Routes for the Enrollment resource:

  # CREATE
  post("/insert_enrollment", { :controller => "enrollments", :action => "create" })
          
  # READ
  get("/enrollments", { :controller => "enrollments", :action => "index" })
  
  get("/enrollments/:path_id", { :controller => "enrollments", :action => "show" })
  
  # UPDATE
  
  post("/modify_enrollment/:path_id", { :controller => "enrollments", :action => "update" })
  
  # DELETE
  get("/delete_enrollment/:path_id", { :controller => "enrollments", :action => "destroy" })

  #------------------------------

  devise_for :users
  root "interviews#index"
  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"
  
end
