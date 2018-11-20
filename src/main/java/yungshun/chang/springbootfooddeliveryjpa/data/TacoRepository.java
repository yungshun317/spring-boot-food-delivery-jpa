package yungshun.chang.springbootfooddeliveryjpa.data;

import org.springframework.data.repository.CrudRepository;
import yungshun.chang.springbootfooddeliveryjpa.Taco;

public interface TacoRepository extends CrudRepository<Taco, Long> {
}
