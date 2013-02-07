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

    def series_chart(data, date_from, date_to)
        #returns {user1: [data_count_by_day], user2: [data_count_by_day], ...}
        data_by_day = data.where(created_at: (date_from.beginning_of_day.to_date..date_to.end_of_day.to_date)).
                            group("user_id, date(created_at)").
                            select("user_id, created_at, count(created_at) as nr_reads")
        date_array = *(date_from.to_date..date_to.to_date)
        r = Hash.new{|h,k| h[k] = [0]*date_array.count}
        data_by_day.each do |d|
            r[d.user_id][date_array.index(d.created_at.to_date)] = d.nr_reads
        end
        return r
    end

    def series_chart_from_a(data_array, date_from, date_to)
        #returns {user1: [data_count_by_day], user2: [data_count_by_day], ...}
        user_group = data_array.group_by(&:user_id)
        date_array = *(date_from.to_date..date_to.to_date)
        r = Hash.new{|h,k| h[k] = [0]*date_array.count}
        user_group.each do |u_id, dates|
            dates.group_by(&:created_at).each do |date,values|
                puts "date: " + date.to_date.to_s
                puts "value: " + values.count.to_s
                puts "user: " + u_id.to_s
                puts "data: " + r[u_id].to_s
                puts "index: " + date_array.index(date.to_date).to_s
                r[u_id][date_array.index(date.to_date)] = values.count
            end
        end
        return r
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
