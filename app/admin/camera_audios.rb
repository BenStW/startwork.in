ActiveAdmin.register CameraAudio do
   menu :priority => 2
   
   filter :user
   filter :video_success
   filter :audio_success
   scope  :problems

   index do
       h2 "Camera und Audio Test"
       column :user
       column :video_success
       column :audio_success
     end
   
end
