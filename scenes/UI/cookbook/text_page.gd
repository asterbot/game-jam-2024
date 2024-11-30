extends PanelContainer

func set_page_number(num):
	%PageNumber.text = str(num)

func update_text(updated_text):
	%Description.text = updated_text
