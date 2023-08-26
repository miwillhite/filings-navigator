import React from 'react';
import { Button, SelectMenu, Pane, TextInputField } from 'evergreen-ui';

// Make a unique list (used for foreign key select menus)
const makeUniqueSetFor = (prop, list) => [...new Set(list.map(x => x[prop]).filter(x => x))];

const AwardFilters = ({ results, onFilterChange }) => {
  const [selectedFiling, setSelectedFiling] = React.useState(null);
  const [filingIds, setFilingIds] = React.useState([]);

  React.useEffect(() => {
    // Only set this when we first pull down the "pristine" data set
    setFilingIds(filingIds => filingIds.length === 0 ? makeUniqueSetFor('filing_id', results) : filingIds);
  }, [results]);

  return (
    <Pane marginTop={16}>
      <TextInputField
        label="Minimum cash award amount"
        hint="Coming soon! Debounced inputs 😅"
        placeholder="5000"
        onChange={e => onFilterChange({ cash_amount_min: e.target.value })}
      />
      <TextInputField
        label="Maximum cash award amount"
        hint="Try less than Infinity"
        placeholder="10000"
        onChange={e => onFilterChange({ cash_amount_max: e.target.value })}
      />

      <SelectMenu
        title="Select Filing ID"
        options={filingIds.map((id) => ({ label: `Filing: ${id}`, value: id.toString() }))}
        hasFilter={false}
        hasTitle={false}
        selected={selectedFiling}
        onSelect={(item) => {
          onFilterChange({ filing_id: item.value })
          setSelectedFiling(item.value);
        }}
      >
        <Button>{selectedFiling || 'Select Filing...'}</Button>
      </SelectMenu>
    </Pane>
  )
};

const STATES = [
  "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
  "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
  "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
  "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
  "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY",
];

const FilersFilters = ({ results, onFilterChange }) => {
  const [selectedState, setSelectedState] = React.useState(null);
  return (
    <Pane marginTop={16}>
      <SelectMenu
        title="Select State"
        options={STATES.map((label) => ({ label, value: label }))}
        hasTitle={false}
        selected={selectedState}
        onSelect={(item) => {
          onFilterChange({ state: item.value });
          setSelectedState(item.value);
        }}
      >
        <Button>{selectedState || 'Select State...'}</Button>
      </SelectMenu>
    </Pane>
  );
};

const FilingsFilters = ({ results, onFilterChange }) => {
  const [selectedFiler, setSelectedFiler] = React.useState(null);
  const [filerIds, setFilerIds] = React.useState([]);

  React.useEffect(() => {
    // Only set this when we first pull down the "pristine" data set
    setFilerIds(filerIds => filerIds.length === 0 ? makeUniqueSetFor('filer_id', results) : filerIds);
  }, [results]);

  return (
    <Pane marginTop={16}>
      <SelectMenu
        title="Select Filer ID"
        options={filerIds.map((id) => ({ label: `Filer: ${id}`, value: id }))}
        hasFilter={false}
        hasTitle={false}
        selected={selectedFiler}
        onSelect={(item) => {
          onFilterChange({ filer_id: item.value })
          setSelectedFiler(item.value);
        }}
      >
        <Button>{selectedFiler || 'Select Filer...'}</Button>
      </SelectMenu>
    </Pane>
  );
};

const RecipientsFilters = ({ results, onFilterChange }) => {
  const [selectedFiling, setSelectedFiling] = React.useState(null);
  const [selectedState, setSelectedState] = React.useState(null);
  const [filingIds, setFilingIds] = React.useState([]);

  React.useEffect(() => {
    // Only set this when we first pull down the "pristine" data set
    setFilingIds(filingIds => filingIds.length === 0 ? makeUniqueSetFor('filing_id', results) : filingIds);
  }, [results]);

  return (
    <Pane marginTop={16}>
      <TextInputField
        label="Minimum cash award amount"
        hint="Coming soon! Debounced inputs 😅"
        placeholder="5000"
        onChange={e => onFilterChange({ cash_amount_min: e.target.value })}
      />
      <TextInputField
        label="Maximum cash award amount"
        hint="Try less than Infinity"
        placeholder="10000"
        onChange={e => onFilterChange({ cash_amount_max: e.target.value })}
      />

      <Pane>
        <SelectMenu
          title="Select Filing ID"
          options={filingIds.map((id) => ({ label: `Filing: ${id}`, value: id.toString() }))}
          hasFilter={false}
          hasTitle={false}
          selected={selectedFiling}
          onSelect={(item) => {
            onFilterChange({ filing_id: item.value })
            setSelectedFiling(item.value);
          }}
        >
          <Button>{selectedFiling || 'Select Filing...'}</Button>
        </SelectMenu>
      </Pane>

      <Pane>
        <SelectMenu
          title="Select State"
          options={STATES.map((label) => ({ label, value: label }))}
          hasTitle={false}
          selected={selectedState}
          onSelect={(item) => {
            onFilterChange({ state: item.value });
            setSelectedState(item.value);
          }}
        >
          <Button>{selectedState || 'Select State...'}</Button>
        </SelectMenu>
      </Pane>
    </Pane>
  )
};

export const FilterInput = ({ selectedModel, results, onFilterChange }) => {
  switch(selectedModel) {
    case 'awards':
      return <AwardFilters results={results} onFilterChange={onFilterChange} />;
    case 'filers':
      return <FilersFilters results={results} onFilterChange={onFilterChange} />;
    case 'filings':
      return <FilingsFilters results={results} onFilterChange={onFilterChange} />;
    case 'recipients':
      return <RecipientsFilters results={results} onFilterChange={onFilterChange} />;
    default:
      return null;
  }
};
