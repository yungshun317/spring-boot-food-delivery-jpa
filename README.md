# Spring Boot Food Delivery JPA

 [![Made with JAVA](https://img.shields.io/badge/Made%20with-JAVA-red.svg)](https://img.shields.io/badge/Made%20with-JAVA-red.svg) [![Spring Framework](https://img.shields.io/badge/Framework-Spring-orange.svg)](https://img.shields.io/badge/Framework-Spring-orange.svg) [![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) 

This project talks about persisting data with Spring Data JPA. It's modified from the example of the [Spring in Action, 5th Edition](https://www.manning.com/books/spring-in-action-fifth-edition) book.

## Up & Running
1. Run `@SpringBootApplication public class SpringBootFoodDeliveryJpaApplication`.
2. Preload ingredient data. Go to `localhost:8080/h2-console`. Login. Copy and paste the content of the `data.sql` file. Click `Run`. More details about H2 Console, please refer to the H2 section below.
3. Go to `localhost:8080`. Click on `Design a taco`.
4. On `localhost:8080/design`, select ingredients you want, name your taco creation, and click `submit your taco`.
5. On `localhost:8080/orders/current`, you can see your taco in this order. Then you can choose to `design another taco` or `submit order`. 
 - The former will direct you back to `localhost:8080/design`. After you submit your another taco, you then come back to `localhost:8080/orders/current`. And you can see your two tacos in the list.
 - The latter will redirect you to the homepage.
6. Go to the H2 Console. Run `SELECT * FROM TACO;`, `SELECT * FROM TACO_INGREDIENTS;`, `SELECT * FROM TACO_ORDER;`, and `SELECT * FROM TACO_ORDER_TACOS;` respectively. I always encourage people to inspect the data, think about why and how to define schemas.

## Features
Spring Data JPA makes JPA persistence as easy as writing a repository interface.

### Lombok
Lombok's `@NoArgsConstructor` creates a no-arguments constructor for us. We make it private by setting the `access` attribute to `AccessLevel.PRIVATE`. And because there are `final` properties that must be set, you also set the `force` attribute to `true`, which results in the Lombok-generated constructor setting them to null.

The `@Data` implicitly adds a required arguments constructor, but when a `@NoArgsConstructor` is used, that constructor gets removed. An explicit `@RequiredArgsConstructor` ensures that you'll still have a required arguments constructor in addition to the private no-arguments constructor. 

### JPA

To declare the relationship between a `Taco` and its associated `Ingredient` list, you annotate ingredients with `@ManyToMany`. A `Taco` can have many `Ingredient` objects, and an `Ingredient` can be a part of many `Taco`s.

`@PrePersist` set the `createdAt` property to the current date and time before `Taco` is persisted. 

`CrudRepository` declares about a dozen methods for CRUD (create, read, update, delete) operations. Its first parameter is the entity type the repository to persist, the second parameter is the type of the entity ID property.

When generating the repository implementation, Spring Data examines any methods in the repository interface, parses the method name, and attempts to understand the method's purpose in the context of the persisted object. In essence, Spring Data defines a sort of miniature domain-specific language (DSL) where persistence details are expressed in repository method signatures. If you want to customize the repositories to perform queries unique to your domain. The following is the guide:

```java 
List<Order> findByDeliveryZip(String deliveryZip);
```
* verb: find
* (optional) object: imply Order
* By
* predicate: DeliveryZip

```java
List<Order> readOrdersByDeliveryZipAndPlacedAtBetween(String deliveryZip, Date startDate, Date endDate);
```
* verb: read (get and find are also allowed)
* objects: Orders
* By
* predicate: DeliveryZip (match .deliveryZip or .delivery.zip)
* implicit Equals
* And
* predicate: PlacedAt (match .placedAt or .placed.at)
* Between. Other similar operators like:
  * IsAfter, After, IsGreaterThan, GreaterThan
  * IsGreaterThanEqual, GreaterThanEqual
  * IsBefore, Before, IsLessThan, LessThan
  * IsLessThanEqual, LessThanEqual
  * IsBetween, Between
  * IsNull, Null
  * IsNotNull, NotNull
  * IsIn, In
  * IsNotIn, NotIn
  * IsStartingWith, StartingWith, StartsWith
  * IsEndingWith, EndingWith, EndsWith
  * IsContaining, Containing, Contains
  * IsLike, Like
  * IsNotLike, NotLike
  * IsTrue, True
  * IsFalse, False
  * Is, Equals
  * IsNot, Not
  * IgnoringCase, IgnoresCase

```java
List<Order> findByDeliveryToAndDeliveryCityAllIgnoresCase(String deliveryTo, String deliveryCity);
```
* find
* (optional) object: imply Order
* By
* DeliveryTo
* implicit Equals
* And
* DeliveryCity
* implicit Equals
* AllIgnoresCase (ignore case for all String comparisons)

```java
List<Order> findByDeliveryCityOrderByDeliveryTo(String city);
```
* find
* (optional) object: imply Order
* By
* DeliveryCity
* OrderBy
* DeliveryTo

```java
@Query("Order o where o.deliveryCity='Seattle'")
List<Order> readOrdersDeliveredInSeattle();
```
* You can use @Query to perform virtually any query you can dream up, even when it's difficult or impossible to achieve the query by following the naming convention.

The `DesignTacoController` class is annotated with `@SessionAttributes("order")`, which specifies any model objects like the `order` attribute that should be kept in session and available across multiple requests so that you can create multiple tacos and add them to the order. And it also has two `@ModelAttribute` annotated methods, `order()` and `design()`, which ensure that an `Order` object and a `Taco` object will be created in the model. The Order parameter annotated with `@ModelAttribute` in the `processDesign()` method indicates that, unlike the `Taco` object, its value should come from the model and that Spring MVC shouldn't attempt to bind request parameters to it.

In the `processOrder()` method of the `OrderController` class, the `Order` object submitted in the form is saved via the `save()` method on the injected `OrderRepository`. The method asks for a `SessionStatus` parameter and calls its `setComplete()` method to reset the session.

### H2
Because we have Spring Boot DevTools in place, we can access the H2 Console via `http://localhost:8080/h2-console`. The login informations you need to enter are as below:
```yaml
Login:
  Saved Settings: Generic H2 (Embedded)
  Setting Name: Generic H2 (Embedded)

  Driver Class: org.h2.Driver
  JDBC URL: jdbc:h2:mem:testdb
  User Name: sa
  Password: 
```

Then click on `Connect`. In fact, the two `.sql` files placed in `src/main/resources/` are not required thanks to JPA. You can copy and paste the statements in `data.sql` to preload the ingredient data into H2. 

We also add `spring.jpa.show-sql=true` to the `application.properties` file to print SQL commands used by Hibernate. They are:
```sh
Hibernate: drop table ingredient if exists
Hibernate: drop table taco if exists
Hibernate: drop table taco_ingredients if exists
Hibernate: drop table taco_order if exists
Hibernate: drop table taco_order_tacos if exists
Hibernate: drop sequence if exists hibernate_sequence
Hibernate: create sequence hibernate_sequence start with 1 increment by 1
Hibernate: create table ingredient (id varchar(255) not null, name varchar(255), type integer, primary key (id))
Hibernate: create table taco (id bigint not null, created_at timestamp, name varchar(255) not null, primary key (id))
Hibernate: create table taco_ingredients (taco_id bigint not null, ingredients_id varchar(255) not null)
Hibernate: create table taco_order (id bigint not null, cccvv varchar(255), cc_expiration varchar(255), cc_number varchar(255), delivery_city varchar(255), delivery_name varchar(255), delivery_state varchar(255), delivery_street varchar(255), delivery_zip varchar(255), placed_at timestamp, primary key (id))
Hibernate: create table taco_order_tacos (order_id bigint not null, tacos_id bigint not null)
Hibernate: alter table taco_ingredients add constraint FK7y679y77n5e75s3ss1v7ff14j foreign key (ingredients_id) references ingredient
Hibernate: alter table taco_ingredients add constraint FK27rycuh3mjaepnba0j6m8xl4q foreign key (taco_id) references taco
Hibernate: alter table taco_order_tacos add constraint FKfwvqtnjfview9e5f7bfqtd1ns foreign key (tacos_id) references taco
Hibernate: alter table taco_order_tacos add constraint FKcxwvdkndaqmrxcen10vkneexo foreign key (order_id) references taco_order
```

## Tech
The tech stack I use in this project:
* [IntelliJ](https://www.jetbrains.com/idea/) - a Java integrated development environment (IDE) for developing computer software developed by JetBrains.
* [Spring Boot](http://spring.io/projects/spring-boot) - a new way to create Spring applications with ease.

## Todos

 - Learn about Spring Data MongoDB, Spring Data Neo4j, Spring Data Redis, Spring Data Cassandra.
 - More Spring projects.
 - Spring Cloud.

## License
[Spring Boot Food Delivery JPA](https://github.com/yungshun317/spring-boot-food-delivery-jpa) is released under the [MIT License](https://opensource.org/licenses/MIT) by [yungshun317](https://github.com/yungshun317).
