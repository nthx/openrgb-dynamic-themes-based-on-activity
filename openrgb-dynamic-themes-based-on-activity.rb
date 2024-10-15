#!/usr/bin/env ruby
#https://superuser.com/questions/176754/get-a-list-of-open-windows-in-linux

class NotifyViaRgb

  #OPENRGB_BIN='/opt/OpenRGB/openrgb'
  OPENRGB_BIN='/usr/bin/openrgb'
  # -z .. zones
  # -d .. device 0: asus mobo, 1 - logitech keyboard
  # -s size of specified device zone

  # only these can reset RGB state and actually control them
  #PATH_PARAMS="-d 0 -z 1 -s 5"
  PATH_PARAMS="--loglevel 0 -d 0 -z 1 -s 5"

  #START_PROFILE = '-m Static -c 000011'
  #DEFAULT_PROFILE_DAY = '-m Static -c 0000AA'
  #DEFAULT_PROFILE_NIGHT = '-m Static -c 000022'
  START_PROFILE = '-m Static -c FF0000'
  DEFAULT_PROFILE_DAY = '-m Static -c FFFF22'
  DEFAULT_PROFILE_NIGHT = '-m Static -c BB0000'

  SSH_PROD_PROFILE = '-m Flashing -c FF0000'
  SLACK_NEW_MSG_PROFILE = '-m Breathing -c 0000FF'
  QUAKE3_PROFILE = '-m Static -c 220000'
  ZOOM_PROFILE = '-m Static -c FFFFFF'
  GMEET_PROFILE = '-m Static -c FFFFFF'

  HOUR_DAY_START = 9
  HOUR_DAY_END = 18

  def initialize
    @current_profile = nil

    abort "#{OPENRGB_BIN} not found" unless File.exist? OPENRGB_BIN
  end

  def main
    log "Welcome to OpenRGB dynamic themes switcher based on your activity.\n"

    change_profile START_PROFILE

    while true do
      log "\nChecking.."
      if has_zoom_meeting_running?
        log "Found Zoom.."
        change_profile ZOOM_PROFILE
      elsif has_gmeet_meeting_running?
        log "Found GMeet.."
        change_profile GMEET_PROFILE
      elsif has_s_prod_running?
        log "Found ssh.."
        change_profile SSH_PROD_PROFILE
      elsif has_new_slack_message?
        log "Found slack.."
        change_profile SLACK_NEW_MSG_PROFILE
      elsif has_quake3_running?
        log "Found Q3.."
        change_profile QUAKE3_PROFILE
      else
        if day?
          log "Found just day.."
          change_profile! DEFAULT_PROFILE_DAY
        else
          log "Found just night.."
          change_profile! DEFAULT_PROFILE_NIGHT
        end
      end

      sleep 2
    end
  end

  private

  def has_s_prod_running?
    ps=`ps fxa | grep [s]sh | grep s-prod-`
    ps.to_s.split("\n").size > 0
  end

  def has_quake3_running?
    ps=`ps fxa | grep [i]oquake3`
    ps.to_s.split("\n").size > 0
  end

  def has_zoom_meeting_running?
    cmd = `wmctrl -l | grep -i [z]oom`
    cmd.to_s.split("\n").size > 0
  end
      
  def has_gmeet_meeting_running?
    cmd = `wmctrl -l | egrep -i "Meet.*Google"`
    cmd.to_s.split("\n").size > 0
  end

  def has_new_slack_message?
    cmd = `wmctrl -l | grep [S]lack | grep "new item"`
    cmd.to_s.split("\n").size > 0
  end

  # NOTE: this sometimes doesn't apply a profile
  def change_profile(profile)
    if @current_profile != profile
      change_profile!(profile)
    end
  end

  def change_profile!(profile)
    log "setting new profile: #{profile}"
    cmd="#{OPENRGB_BIN} #{PATH_PARAMS} #{profile}"
    log cmd
    out=`#{cmd}`
    log out
    @current_profile = profile
  end

  def day?
    hour = (Time.now.strftime '%H').to_i
    hour >= HOUR_DAY_START && hour <= HOUR_DAY_END
  end

  def log(s)
    puts "#{Time.now}: #{s}"
  end
end

puts "XXX: Removing log files.."
cmd="rm ~/.config/OpenRGB/logs/*"
out=`#{cmd}`
puts "..done."

NotifyViaRgb.new.main
