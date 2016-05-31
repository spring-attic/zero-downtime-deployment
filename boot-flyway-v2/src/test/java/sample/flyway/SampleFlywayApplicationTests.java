/*
 * Copyright 2012-2014 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package sample.flyway;

import org.junit.Test;
import org.junit.runner.RunWith;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(SampleFlywayApplicationV2.class)
public class SampleFlywayApplicationTests {

	@Autowired private JdbcTemplate template;

	@Autowired private PersonRepository personRepository;

	@Autowired private PersonController personController;

	@Test
	public void testDefaultSettings() throws Exception {
		assertEquals(new Integer(1), this.template
				.queryForObject("SELECT COUNT(*) from PERSON", Integer.class));
		Person person = personRepository.findAll().iterator().next();
		assertEquals(person.getFirstName(), "Dave");
		assertEquals(person.getLastName(), "Syer");
		assertEquals(person.getSurname(), "Syer");
	}

	@Test
	public void should_insert_into_both_columns() throws Exception {
		personController.generatePerson();
		personController.generatePerson();
		personController.generatePerson();

		Iterable<Person> persons = personRepository.findAll();

		for (Person person : persons) {
			assertNotNull(person.getFirstName());
			assertNotNull(person.getLastName());
			assertEquals(person.getLastName(), person.getSurname());
		}

	}

}
