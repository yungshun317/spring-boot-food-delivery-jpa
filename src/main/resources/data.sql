delete from Taco_Order_Tacos;
delete from Taco_Ingredients;
delete from Taco;
delete from Taco_Order;
delete from Ingredient;

insert into Ingredient (id, name, type) values ('FLTO', 'Flour Tortilla', 0);
insert into Ingredient (id, name, type) values ('COTO', 'Corn Tortilla', 0);
insert into Ingredient (id, name, type) values ('GRBF', 'Ground Beef', 1);
insert into Ingredient (id, name, type) values ('CARN', 'Carnitas', 1);
insert into Ingredient (id, name, type) values ('TMTO', 'Diced Tomatoes', 2);
insert into Ingredient (id, name, type) values ('LETC', 'Lettuce', 2);
insert into Ingredient (id, name, type) values ('CHED', 'Cheddar', 3);
insert into Ingredient (id, name, type) values ('JACK', 'Monterrey Jack', 3);
insert into Ingredient (id, name, type) values ('SLSA', 'Salsa', 4);
insert into Ingredient (id, name, type) values ('SRCR', 'Sour Cream', 4);