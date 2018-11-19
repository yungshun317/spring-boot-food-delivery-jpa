Lombok notes:

Lombok's @NoArgsConstructor creates a no-arguments constructor for us. We make it private by setting the access attribute to AccessLevel.PRIVATE. And because there are final properties that must be set, you also set the force attribute to true, which results in the Lombok-generated constructor setting them to null.

The @Data implicitly adds a required arguments constructor, but when a @NoArgsConstructor is used, that constructor gets removed. An explicit @RequiredArgsConstructor ensures that you'll still have a required arguments constructor in addition to the private no-arguments constructor. 

JPA:

To declare the relationship between a Taco and its associated Ingredient list, you annotate ingredients with @ManyToMany. A Taco can have many Ingredient objects, and an Ingredient can be a part of many Tacos.

@PrePersist set the createdAt property to the current date and time before Taco is persisted. 


