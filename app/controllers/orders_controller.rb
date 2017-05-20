class OrdersController < ApplicationController

skip_before_action :verify_authenticity_token

	def new
		@order = Order.new
	end

	def show
		@order = Order.find(params[:id])
	end

	def create

		 
		# if request.xhr?
		
			# png =  Base64.decode64(params[:data]['data:image/png;base64,'.length .. -1])


		# File.open('pic.png', 'w+b') { |f| f.write(png) }


		#  #need to take out this expression (data:image\/jpeg;base64)
		
		# code = Qrio::Qr.load("pic.png").qr.text
		# if code == '@'
		# 	code = 1
		# end

		b = Box.find_by(address: params[:orders][:pick_up_address])
		# code = ''
		
		 
		
		
		# end
		binding.pry
		
		@order = Order.create(client_id: current_client.id, business_id: 1, box_in: b.id, status: "In Box", paid: false)
		redirect_to new_charge_path
	end

	def update
		@order = Order.find(params[:id])
		if params[:order][:order_status] == nil
			if params[:order][:delivered_address] == ""
				redirect_to root_path and return
			else
				@box = Box.find_by(address: params[:order][:delivered_address])
				@order.update_attributes(:status => "Delivered", :box_out => @box.id)
				@order.save
				current_shipper.update_attributes(box_id: params[:order][:box_id])
				current_shipper.save
				#UserNotifier.send_update_email(@order.client).deliver
			end
		else
			shipper = Shipper.find_by(name: params[:order][:assign_shipper_to_order])
			@order.update_attributes(status: params[:order][:order_status], shipper_id: shipper.id)
			@order.save
		end
		redirect_to root_path
	end

	def shippers
		render "shippers.html.erb"
	end

	def history
	end
end

