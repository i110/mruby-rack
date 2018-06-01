# taken from https://github.com/ruby/ruby/blob/1b91e1ce32081324df82ef1314d468916c237879/lib/time.rb
class Time
  class << Time
    ZoneOffset = { # :nodoc:
      'UTC' => 0,
      # ISO 8601
      'Z' => 0,
      # RFC 822
      'UT' => 0, 'GMT' => 0,
      'EST' => -5, 'EDT' => -4,
      'CST' => -6, 'CDT' => -5,
      'MST' => -7, 'MDT' => -6,
      'PST' => -8, 'PDT' => -7,
      # Following definition of military zones is original one.
      # See RFC 1123 and RFC 2822 for the error in RFC 822.
      'A' => +1, 'B' => +2, 'C' => +3, 'D' => +4,  'E' => +5,  'F' => +6,
      'G' => +7, 'H' => +8, 'I' => +9, 'K' => +10, 'L' => +11, 'M' => +12,
      'N' => -1, 'O' => -2, 'P' => -3, 'Q' => -4,  'R' => -5,  'S' => -6,
      'T' => -7, 'U' => -8, 'V' => -9, 'W' => -10, 'X' => -11, 'Y' => -12,
    }

    MonthValue = {
      'JAN' => 1, 'FEB' => 2, 'MAR' => 3, 'APR' => 4, 'MAY' => 5, 'JUN' => 6,
      'JUL' => 7, 'AUG' => 8, 'SEP' => 9, 'OCT' =>10, 'NOV' =>11, 'DEC' =>12
    }

    def zone_offset(zone, year=self.now.year)
      off = nil
      zone = zone.upcase
      if /\A([+-])(\d\d)(:?)(\d\d)(?:\3(\d\d))?\z/ =~ zone
        off = ($1 == '-' ? -1 : 1) * (($2.to_i * 60 + $4.to_i) * 60 + $5.to_i)
      elsif zone.match?(/\A[+-]\d\d\z/)
        off = zone.to_i * 3600
      elsif ZoneOffset.include?(zone)
        off = ZoneOffset[zone] * 3600
      # NOTE mruby-time doesn't have utc_offset
      # elsif ((t = self.local(year, 1, 1)).zone.upcase == zone rescue false)
      #   off = t.utc_offset
      # elsif ((t = self.local(year, 7, 1)).zone.upcase == zone rescue false)
      #   off = t.utc_offset
      end
      off
    end


    LeapYearMonthDays = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    CommonYearMonthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    def month_days(y, m)
      if ((y % 4 == 0) && (y % 100 != 0)) || (y % 400 == 0)
        LeapYearMonthDays[m-1]
      else
        CommonYearMonthDays[m-1]
      end
    end

    def apply_offset(year, mon, day, hour, min, sec, off)
      if off < 0
        off = -off
        off, o = off.divmod(60)
        if o != 0 then sec += o; o, sec = sec.divmod(60); off += o end
        off, o = off.divmod(60)
        if o != 0 then min += o; o, min = min.divmod(60); off += o end
        off, o = off.divmod(24)
        if o != 0 then hour += o; o, hour = hour.divmod(24); off += o end
        if off != 0
          day += off
          days = month_days(year, mon)
          if days and days < day
            mon += 1
            if 12 < mon
              mon = 1
              year += 1
            end
            day = 1
          end
        end
      elsif 0 < off
        off, o = off.divmod(60)
        if o != 0 then sec -= o; o, sec = sec.divmod(60); off -= o end
        off, o = off.divmod(60)
        if o != 0 then min -= o; o, min = min.divmod(60); off -= o end
        off, o = off.divmod(24)
        if o != 0 then hour -= o; o, hour = hour.divmod(24); off -= o end
        if off != 0 then
          day -= off
          if day < 1
            mon -= 1
            if mon < 1
              year -= 1
              mon = 12
            end
            day = month_days(year, mon)
          end
        end
      end
      return year, mon, day, hour, min, sec
    end

    def rfc2822(date)
      if /\A\s*
          (?:(?:Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s*,\s*)?
          (\d{1,2})\s+
          (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+
          (\d{2,})\s+
          (\d{2})\s*
          :\s*(\d{2})\s*
          (?::\s*(\d{2}))?\s+
          ([+-]\d{4}|
           UT|GMT|EST|EDT|CST|CDT|MST|MDT|PST|PDT|[A-IK-Z])/ix =~ date
        # Since RFC 2822 permit comments, the regexp has no right anchor.
        day = $1.to_i
        mon = MonthValue[$2.upcase]
        year = $3.to_i
        short_year_p = $3.length <= 3
        hour = $4.to_i
        min = $5.to_i
        sec = $6 ? $6.to_i : 0
        zone = $7

        if short_year_p
          # following year completion is compliant with RFC 2822.
          year = if year < 50
                   2000 + year
                 else
                   1900 + year
                 end
        end

        off = zone_offset(zone)
        year, mon, day, hour, min, sec =
          apply_offset(year, mon, day, hour, min, sec, off)
        t = self.utc(year, mon, day, hour, min, sec)
        # NOTE utc only
        # force_zone!(t, zone, off)
        t
      else
        raise ArgumentError.new("not RFC 2822 compliant date: #{date.inspect}")
      end
    end
  end

  RFC2822_DAY_NAME = [
    'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
  ]

  RFC2822_MONTH_NAME = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ]

  def httpdate
    t = dup.utc
    sprintf('%s, %02d %s %0*d %02d:%02d:%02d GMT',
      RFC2822_DAY_NAME[t.wday],
      t.day, RFC2822_MONTH_NAME[t.mon-1], t.year < 0 ? 5 : 4, t.year,
      t.hour, t.min, t.sec)
  end

end
