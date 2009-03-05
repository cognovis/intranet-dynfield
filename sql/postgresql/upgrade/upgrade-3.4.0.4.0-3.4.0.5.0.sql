-- upgrade-3.4.0.4.0-3.4.0.5.0.sql

SELECT acs_log__debug('/packages/intranet-dynfield/sql/postgresql/upgrade/upgrade-3.4.0.4.0-3.4.0.5.0.sql','');






-- Shortcut function
CREATE OR REPLACE FUNCTION im_dynfield_attribute_new (
	varchar, varchar, varchar, varchar, varchar, char(1), integer, char(1)
) RETURNS integer as '
DECLARE
	p_object_type		alias for $1;
	p_column_name		alias for $2;
	p_pretty_name		alias for $3;
	p_widget_name		alias for $4;
	p_datatype		alias for $5;
	p_required_p		alias for $6;
	p_pos_y			alias for $7;
	p_also_hard_coded_p	alias for $8;

	v_dynfield_id		integer;
	v_widget_id		integer;
	v_type_category		varchar;
	row			RECORD;
	v_count			integer;
	v_min_n_value		integer;
BEGIN
	select	widget_id into v_widget_id from im_dynfield_widgets
	where	widget_name = p_widget_name;
	IF v_widget_id is null THEN return 1; END IF;

	select	count(*) from im_dynfield_attributes into v_count
	where	acs_attribute_id in (
			select	attribute_id 
			from	acs_attributes 
			where	attribute_name = p_column_name and
				object_type = p_object_type
		);
	IF v_count > 0 THEN return 1; END IF;

	v_min_n_value := 0;
	IF p_required_p = ''t'' THEN  v_min_n_value := 1; END IF;

	v_dynfield_id := im_dynfield_attribute__new (
		null, ''im_dynfield_attribute'', now(), 0, ''0.0.0.0'', null,
		p_object_type, p_column_name, v_min_n_value, 1, null,
		p_datatype, p_pretty_name, p_pretty_name, p_widget_name,
		''f'', ''f''
	);

	update im_dynfield_attributes set also_hard_coded_p = p_also_hard_coded_p
	where attribute_id = v_dynfield_id;

	insert into im_dynfield_layout (
		attribute_id, page_url, pos_y, label_style
	) values (
		v_dynfield_id, ''default'', p_pos_y, ''table''
	);

	-- set all im_dynfield_type_attribute_map to "edit"
	select type_category_type into v_type_category from acs_object_types
	where object_type = p_object_type;
	FOR row IN
		select	category_id
		from	im_categories
		where	category_type = v_type_category
	LOOP
		select	count(*) into v_count from im_dynfield_type_attribute_map
		where	object_type_id = row.category_id and attribute_id = v_dynfield_id;
		IF 0 = v_count THEN
			insert into im_dynfield_type_attribute_map (
				attribute_id, object_type_id, display_mode
			) values (
				v_dynfield_id, row.category_id, ''edit''
			);
		END IF;
	END LOOP;

	PERFORM acs_permission__grant_permission(v_dynfield_id, (select group_id from groups where group_name=''Employees''), ''read'');
	PERFORM acs_permission__grant_permission(v_dynfield_id, (select group_id from groups where group_name=''Employees''), ''write'');
	PERFORM acs_permission__grant_permission(v_dynfield_id, (select group_id from groups where group_name=''Customers''), ''read'');
	PERFORM acs_permission__grant_permission(v_dynfield_id, (select group_id from groups where group_name=''Customers''), ''write'');
	PERFORM acs_permission__grant_permission(v_dynfield_id, (select group_id from groups where group_name=''Freelancers''), ''read'');
	PERFORM acs_permission__grant_permission(v_dynfield_id, (select group_id from groups where group_name=''Freelancers''), ''write'');

	RETURN v_dynfield_id;
END;' language 'plpgsql';

-- Shortcut function
CREATE OR REPLACE FUNCTION im_dynfield_attribute_new (
	varchar, varchar, varchar, varchar, varchar, char(1)
) RETURNS integer as '
BEGIN
	RETURN im_dynfield_attribute_new($1,$2,$3,$4,$5,$6,null,''f'');
END;' language 'plpgsql';







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







select im_dynfield_widget__new (
	null,			-- widget_id
	'im_dynfield_widget',	-- object_type
	now(),			-- creation_date
	null,			-- creation_user
	null,			-- creation_ip	
	null,			-- context_id
	'category_office_status',			-- widget_name
	'#intranet-core.Office_Status#',	-- pretty_name
	'#intranet-core.Office_Status#',	-- pretty_plural
	10007,			-- storage_type_id
	'integer',		-- acs_datatype
	'im_category_tree',	-- widget
	'integer',		-- sql_datatype
	'{{custom {category_type "Intranet Office Status"}}}'			-- Parameters
);

	
select im_dynfield_widget__new (
	null,			-- widget_id
	'im_dynfield_widget',	-- object_type
	now(),			-- creation_date
	null,			-- creation_user
	null,			-- creation_ip	
	null,			-- context_id
	'category_office_type',			-- widget_name
	'#intranet-core.Office_Type#',	-- pretty_name
	'#intranet-core.Office_Type#',	-- pretty_plural
	10007,			-- storage_type_id
	'integer',		-- acs_datatype
	'im_category_tree',	-- widget
	'integer',		-- sql_datatype
	'{{custom {category_type "Intranet Office Type"}}}'			-- Parameters
);







select im_dynfield_widget__new (
	null,			-- widget_id
	'im_dynfield_widget',	-- object_type
	now(),			-- creation_date
	null,			-- creation_user
	null,			-- creation_ip	
	null,			-- context_id
	'category_company_status',			-- widget_name
	'#intranet-core.Company_Status#',	-- pretty_name
	'#intranet-core.Company_Status#',	-- pretty_plural
	10007,			-- storage_type_id
	'integer',		-- acs_datatype
	'im_category_tree',	-- widget
	'integer',		-- sql_datatype
	'{{custom {category_type "Intranet Company Status"}}}'			-- Parameters
);


select im_dynfield_widget__new (
	null,			-- widget_id
	'im_dynfield_widget',	-- object_type
	now(),			-- creation_date
	null,			-- creation_user
	null,			-- creation_ip	
	null,			-- context_id
	'annual_revenue',			-- widget_name
	'#intranet-core.Annual_Revenue#',	-- pretty_name
	'#intranet-core.Annual_Revenue#',	-- pretty_plural
	10007,			-- storage_type_id
	'integer',		-- acs_datatype
	'im_category_tree',	-- widget
	'integer',		-- sql_datatype
	'{{custom {category_type "Intranet Annual Revenue"}}}'			-- Parameters
);

select im_dynfield_widget__new (
	null,			-- widget_id
	'im_dynfield_widget',	-- object_type
	now(),			-- creation_date
	null,			-- creation_user
	null,			-- creation_ip	
	null,			-- context_id
 	'country_codes',			-- widget_name
	'#intranet-core.Country#',	-- pretty_name
	'#intranet-core.Country#',	-- pretty_plural
	10007,			-- storage_type_id
	'string',		-- acs_datatype
	'generic_sql',	-- widget
	'char(3)',		-- sql_datatype
	'{{custom {sql "select iso,country_name from country_codes order by country_name"}}}'			-- Parameters
);

update im_dynfield_widgets set deref_plpgsql_function = 'im_country_from_code' where widget_name =  'country_codes';

