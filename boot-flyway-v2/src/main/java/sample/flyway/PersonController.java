package sample.flyway;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

/**
 * @author Marcin Grzejszczak
 */
@RestController
@RequestMapping("/person")
public class PersonController {

	@Autowired PersonRepository personRepository;

	// The API hasn't changed - only the code has
	@RequestMapping(method = RequestMethod.POST)
	public Person generatePerson() {
		Person person = new Person();
		UUID uuid = UUID.randomUUID();
		person.setFirstName(uuid.toString());
		person.setSurname(uuid.toString());
		return personRepository.save(person);
	}

}
