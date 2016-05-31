/*
 * Copyright 2012-2016 the original author or authors.
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

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Person {
	@Id
	@GeneratedValue
	private Long id;
	private String firstName;
	private String lastName;
	private String surname;

	public String getFirstName() {
		return this.firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return this.lastName;
	}

	/**
	 * Reading from the old column since it's most up to date. When there was a migration script ran
	 * some entries were added to the old column.
	 */
	public String getSurname() {
		return this.lastName;
	}

	/**
	 * Storing both FIRST_NAME and SURNAME entries
	 */
	public void setSurname(String surname) {
		this.lastName = surname;
		this.surname = surname;
	}

	@Override
	public String toString() {
		return "Person [firstName=" + this.firstName + ", lastName=" + this.lastName + ", surname=" + this.surname
				+ "]";
	}
}
