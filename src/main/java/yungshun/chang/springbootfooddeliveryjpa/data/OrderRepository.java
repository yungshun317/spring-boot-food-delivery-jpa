package yungshun.chang.springbootfooddeliveryjpa.data;

import org.springframework.data.repository.CrudRepository;
import yungshun.chang.springbootfooddeliveryjpa.Order;

public interface OrderRepository extends CrudRepository<Order, Long> {
}
