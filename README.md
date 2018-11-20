Lombok notes:

Lombok's @NoArgsConstructor creates a no-arguments constructor for us. We make it private by setting the access attribute to AccessLevel.PRIVATE. And because there are final properties that must be set, you also set the force attribute to true, which results in the Lombok-generated constructor setting them to null.

The @Data implicitly adds a required arguments constructor, but when a @NoArgsConstructor is used, that constructor gets removed. An explicit @RequiredArgsConstructor ensures that you'll still have a required arguments constructor in addition to the private no-arguments constructor. 

JPA:

To declare the relationship between a Taco and its associated Ingredient list, you annotate ingredients with @ManyToMany. A Taco can have many Ingredient objects, and an Ingredient can be a part of many Tacos.

@PrePersist set the createdAt property to the current date and time before Taco is persisted. 

CrudRepository declares about a dozen methods for CRUD (create, read, update, delete) operations. Its first parameter is the entity type the repository to persist, the second parameter is the type of the entity ID property.

When generating the repository implementation, Spring Data examines any methods in the repository interface, parses the method name, and attempts to understand the method's purpose in the context of the persisted object. In essence, Spring Data defines a sort of miniature domain-specific language (DSL) where persistence details are expressed in repository method signatures. If you want to customize the repositories to perform queries unique to your domain. The following is the guide:
 
List<Order> findByDeliveryZip(String deliveryZip);
* verb: find
* (optional) object: imply Order
* By
* predicate: DeliveryZip

List<Order> readOrdersByDeliveryZipAndPlacedAtBetween(String deliveryZip, Date startDate, Date endDate);
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

List<Order> findByDeliveryToAndDeliveryCityAllIgnoresCase(String deliveryTo, String deliveryCity);
* find
* (optional) object: imply Order
* By
* DeliveryTo
* implicit Equals
* And
* DeliveryCity
* implicit Equals
* AllIgnoresCase (ignore case for all String comparisons)

List<Order> findByDeliveryCityOrderByDeliveryTo(String city);
* find
* (optional) object: imply Order
* By
* DeliveryCity
* OrderBy
* DeliveryTo

@Query("Order o where o.deliveryCity='Seattle'")
List<Order> readOrdersDeliveredInSeattle();
* You can use @Query to perform virtually any query you can dream up, even when it's difficult or impossible to achieve the query by following the naming convention.
