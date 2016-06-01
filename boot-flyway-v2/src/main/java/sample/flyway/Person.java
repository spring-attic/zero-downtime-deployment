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

	/**
	 * Reading from the new column if it's set. If not the from the old one.
	 *
	 * When migrating from version 1.0.0 -> 2.0.0 this can lead to a possibility that some data in
	 * the surname column is not up to date (during the migration process lastName could have been updated).
	 * In this case one can run yet another migration script after all applications have been deployed in the
	 * new version to ensure that the surname field is updated.
	 *
	 * However it makes sense since when looking at the migration from 2.0.0 -> 3.0.0. In 3.0.0 we no longer
	 * have a notion of lastName at all - so we don't update that column. If we rollback from 3.0.0 -> 2.0.0 if we
	 * would be reading from lastName, then we would have very old data (since not a single datum was inserted
	 * to lastName in version 3.0.0).
	 */
	public String getSurname() {
		return this.surname != null ? this.surname : this.lastName;
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
