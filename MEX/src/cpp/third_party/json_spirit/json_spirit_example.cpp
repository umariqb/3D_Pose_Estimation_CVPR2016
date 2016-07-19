#include <iostream>
#include <string>

#include "cpp/third_party/json_spirit/json_spirit.h"

int main() {
	std::cout << "So far, so good\n";
	// Do not use '<string>' in your json file, parsing will fail.
	const std::string sample = "{\"a\":true, \"b\":1, \"c\":[1,2,3,4]}";
	std::cout << "Parsing " << sample << "\n";
	json_spirit::mValue value;
	if (!json_spirit::read(sample, value)) {
		std::cerr << "Error while parsing json string.\n";
		return 1;
	}

	json_spirit::write_formatted(value, std::cout);

	const json_spirit::mObject& obj = value.get_obj();
	json_spirit::mObject::const_iterator it = obj.find("c");

	assert(it != obj.end());
	assert(it->first == "c");
	const json_spirit::mArray& arr = it->second.get_array();
	int sum = 0;
	for (size_t i = 0; i < arr.size(); ++i) {
		sum += arr[i].get_int();
	}
	std::cout << "\nSum in array: " << sum << "\n";

	return 0;
}
