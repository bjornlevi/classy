module ApplicationHelper
	def safe_html_output(content)
		s = sanitize content
		if s == ""
			content
		else
			s.html_safe
		end
	end

	def summarize(body, length)
		simple_format(truncate(body.gsub(/<\/?.*?>/,  ""), :length => length)).gsub(/<\/?.*?>/,  "")
	end

    def date_format(date)
        date.strftime("%m/%d/%Y")
    end

    def user_reads_chart(user, date_from, date_to)
        #date_from and date_to must be date objects
        reads_by_day = user.reads.where(created_at: (date_from.beginning_of_day.to_date..date_to.end_of_day.to_date)).
                            group("date(created_at)").
                            select("created_at, count(created_at) as nr_reads")
        (date_from.to_date..date_to.to_date).map do |date|
            read = reads_by_day.detect { |read| read.created_at.to_date == date }
            read && read.nr_reads || 0
        end.inspect
    end

	def line_chart(data, axis, colors, legend = "", title="", size="450x150")
       Gchart.line(
        :title => title + ": " + @user.name,
        :size => size,
        :data => data, 
        :axis_with_labels => 'x,y',
        :axis_labels => axis,
        :line_colors => colors,
        :legend => legend)
	end

	def bar_chart(data, axis, colors, width_and_spacing="2,0", legend="", title="", size="450x150")
      Gchart.bar(
        :title => title + ": " + @user.name,
        :size => size,
        :data => data, 
        :axis_with_labels => 'x,y',
        :axis_labels => axis,
        :bar_colors => colors,
        :bar_width_and_spacing => width_and_spacing,
        :legend => legend)
	end

    def scatter_chart(data, axis, size="450x150")
      Gchart.scatter(
        :size => size,
        :data => data, 
        :axis_with_labels => 'x,y',
        :axis_labels => axis,
        :font_size => 26)
    end

    def meter_chart(data, label, size="100x100")
        Gchart.meter(
            :data => data, 
            :size => size,
            :label => label)
    end
end
