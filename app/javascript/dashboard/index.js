import React from 'react';
import { Heading, Table, Pane, Combobox } from 'evergreen-ui';
import { FilterInput } from './filter_input';

const MODELS = [
  'awards',
  'filers',
  'filings',
  'recipients',
];

export const Dashboard = () => {
  const [results, setResults] = React.useState([]);
  const [selectedModel, setSelectedModel] = React.useState(MODELS[0]);
  const [filters, setFilters] = React.useState({});

  React.useEffect(() => {
    const fetchResults = async () => {
      const params = new URLSearchParams(filters).toString();
      const apiPath = [`/api/v1/${selectedModel}`, params].join('?');
      const response = await fetch(apiPath);
      setResults(await response.json());
    }

    fetchResults();
  }, [selectedModel, filters]);

  React.useEffect(() => {
    // Reset filters when model changes
    setResults([]);
    setFilters({});
  }, [selectedModel]);

  const updateFilter = (newFilter) => {
    setFilters(filters => ({ ...filters, ...newFilter }));
  };

  return(
    <Pane className="dashboard-container">
      <Pane background="tint1" className="filters">
        <Combobox
          items={MODELS}
          onChange={setSelectedModel}
          selectedItem={selectedModel}
          placeholder="Select a model…"
          autocompleteProps={{
            title: 'Model'
          }}
        />
        <FilterInput selectedModel={selectedModel} results={results} onFilterChange={updateFilter} />
      </Pane>
      <Pane className="results-table">
        {
          results.length === 0
          ? <Heading>Loading…or empty…if only we knew…</Heading>
          : <Table>
              <Table.Body>
                <Table.Head>
                  {Object.keys(results[0]).map((key) =>
                    <Table.HeaderCell key={key}>{key}</Table.HeaderCell>
                  )}
                </Table.Head>
                {results.map(result =>
                  <Table.Row key={result.id}>
                    {Object.entries(result).map(([key, value]) =>
                      <Table.TextCell key={key}>{value}</Table.TextCell>
                    )}
                  </Table.Row>
                )}
              </Table.Body>
            </Table>
        }
      </Pane>
    </Pane>
  );
};