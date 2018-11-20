package yungshun.chang.springbootfooddeliveryjpa.data;

import org.springframework.data.repository.CrudRepository;
import yungshun.chang.springbootfooddeliveryjpa.Ingredient;

public interface IngredientRepository extends CrudRepository<Ingredient, String> {
}
