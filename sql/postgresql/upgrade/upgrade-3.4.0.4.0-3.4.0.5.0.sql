-- upgrade-3.4.0.4.0-3.4.0.5.0.sql

SELECT acs_log__debug('/packages/intranet-dynfield/sql/postgresql/upgrade/upgrade-3.4.0.4.0-3.4.0.5.0.sql','');






-- Make sure acs_rels is correctly entered in acs_attributes 
-- so the relationship Classes can work

------------------------------------------------------
-- Make acs_rels a proper object for XoTCL
------------------------------------------------------

create or replace function inline_0 ()
returns integer as '
declare
	v_count		integer;
begin
	select	count(*) into v_count from acs_object_type_tables
	where	object_type = ''relationship'' and table_name = ''acs_rels'';
	IF v_count > 0 THEN return 0; END IF;

	insert into acs_object_type_tables (
		object_type,table_name,id_column
	) values (
		''relationship'',''acs_rels'',''rel_id''
	);

	return 0;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();

SELECT im_dynfield_attribute_new ('relationship', 'object_id_one', 'Object ID One', 'integer', 'integer', 't');
SELECT im_dynfield_attribute_new ('relationship', 'object_id_two', 'Object ID Two', 'integer', 'integer', 't');
SELECT im_dynfield_attribute_new ('relationship', 'rel_type', 'Relationship Type', 'textbox_medium', 'string', 't');



------------------------------------------------------
-- Make im_biz_object_members a proper object for XoTCL
------------------------------------------------------


create or replace function inline_0 ()
returns integer as '
declare
	v_count		integer;
begin
	select	count(*) into v_count from acs_object_type_tables
	where	object_type = ''im_biz_object_member'' and table_name = ''im_biz_object_members'';
	IF v_count > 0 THEN return 0; END IF;

	insert into acs_object_type_tables (
		object_type,table_name,id_column
	) values (
		''im_biz_object_member'',''im_biz_object_members'',''rel_id''
	);

	return 0;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();

SELECT im_dynfield_attribute_new ('im_biz_object_member', 'object_role_id', 'Biz Object Role', 'biz_object_member_type', 'integer', 't');
SELECT im_dynfield_attribute_new ('im_biz_object_member', 'percentage', 'Assignment Percentage', 'integer', 'integer', 'f');




------------------------------------------------------
--
------------------------------------------------------

create or replace function inline_0 ()
returns integer as '
declare
	v_count		integer;
begin
	select	count(*) into v_count
	from	user_tab_columns 
	where	lower(table_name) = ''im_dynfield_type_attribute_map'' and 
		lower(column_name) = ''help_text'';
	IF 0 != v_count THEN return 0; END IF;

	alter table im_dynfield_type_attribute_map
	add column help_text text;

	return 0;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();


create or replace function inline_0 ()
returns integer as '
declare
	v_count		integer;
begin
	select	count(*) into v_count
	from	user_tab_columns 
	where	lower(table_name) = ''im_dynfield_type_attribute_map'' and 
		lower(column_name) = ''section_heading'';
	IF 0 != v_count THEN return 0; END IF;

	alter table im_dynfield_type_attribute_map
	add column section_heading text;

	return 0;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();


create or replace function inline_0 ()
returns integer as '
declare
	v_count		integer;
begin
	select	count(*) into v_count
	from	user_tab_columns 
	where	lower(table_name) = ''im_dynfield_type_attribute_map'' and 
		lower(column_name) = ''default_value'';
	IF 0 != v_count THEN return 0; END IF;

	alter table im_dynfield_type_attribute_map
	add column default_value text;

	return 0;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();


create or replace function inline_0 ()
returns integer as '
declare
	v_count		integer;
begin
	select	count(*) into v_count
	from	user_tab_columns 
	where	lower(table_name) = ''im_dynfield_type_attribute_map'' and 
		lower(column_name) = ''required_p'';
	IF 0 != v_count THEN return 0; END IF;

	alter table im_dynfield_type_attribute_map
	add column required_p char(1) default ''f'';

	return 0;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();


-- 22000-22999 Intranet User Type
SELECT im_category_new(22000, 'Registered Users', 'Intranet User Type');
SELECT im_category_new(22010, 'The Public', 'Intranet User Type');
SELECT im_category_new(22020, 'P/O Admins', 'Intranet User Type');
SELECT im_category_new(22030, 'Customers', 'Intranet User Type');
SELECT im_category_new(22040, 'Employees', 'Intranet User Type');
SELECT im_category_new(22050, 'Freelancers', 'Intranet User Type');
SELECT im_category_new(22060, 'Project Managers', 'Intranet User Type');
SELECT im_category_new(22070, 'Senior Managers', 'Intranet User Type');
SELECT im_category_new(22080, 'Accounting', 'Intranet User Type');
SELECT im_category_new(22090, 'Sales', 'Intranet User Type');
SELECT im_category_new(22100, 'HR Managers', 'Intranet User Type');
SELECT im_category_new(22110, 'Freelance Managers', 'Intranet User Type');

-- Set Object Subtypes field
update acs_object_types set type_category_type = 'Intranet Absence Type' where object_type = 'im_user_absence';
update acs_object_types set type_category_type = 'Intranet Company Type' where object_type = 'im_company';
update acs_object_types set type_category_type = 'Intranet Cost Center Type' where object_type = 'im_cost_center';
update acs_object_types set type_category_type = 'Intranet Cost Type' where object_type = 'im_cost';
update acs_object_types set type_category_type = 'Intranet Expense Type' where object_type = 'im_expense';
update acs_object_types set type_category_type = 'Intranet Freelance RFQ Type' where object_type = 'im_freelance_rfq';
update acs_object_types set type_category_type = 'Intranet Investment Type' where object_type = 'im_investment';
update acs_object_types set type_category_type = 'Intranet Cost Type' where object_type = 'im_invoice';
update acs_object_types set type_category_type = 'Intranet Material Type' where object_type = 'im_material';
update acs_object_types set type_category_type = 'Intranet Office Type' where object_type = 'im_office';
update acs_object_types set type_category_type = 'Intranet Payment Type' where object_type = 'im_payment';
update acs_object_types set type_category_type = 'Intranet Project Type' where object_type = 'im_project';
update acs_object_types set type_category_type = 'Intranet Report Type' where object_type = 'im_report';
update acs_object_types set type_category_type = 'Intranet Timesheet2 Conf Type' where object_type = 'im_timesheet_conf_object';
update acs_object_types set type_category_type = 'Intranet Timesheet Task Type' where object_type = 'im_timesheet_task';
update acs_object_types set type_category_type = 'Intranet Topic Type' where object_type = 'im_forum_topic';
update acs_object_types set type_category_type = 'Intranet User Type' where object_type = 'person';

